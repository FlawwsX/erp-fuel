local FuelClasses = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 0.8, -- SUVs
	[3] = 1.2, -- Coupes
	[4] = 1.1, -- Muscle
	[5] = 1.3, -- Sports Classics
	[6] = 1.2, -- Sports
	[7] = 1.2, -- Super
	[8] = 0.8, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 0.8, -- Industrial
	[11] = 0.8, -- Utility
	[12] = 0.8, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.2, -- Service
	[18] = 1.2, -- Emergency
	[19] = 1.2, -- Military
	[20] = 1.2, -- Commercial
	[21] = 1.0, -- Trains
}

local FuelUsage = {
	[1.0] = 0.4,
	[0.9] = 0.4,
	[0.8] = 0.3,
	[0.7] = 0.3,
	[0.6] = 0.2,
	[0.5] = 0.2,
	[0.4] = 0.1,
	[0.3] = 0.1,
	[0.2] = 0.1,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

local GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(1784.324, 3330.55, 41.253)
}

local function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function SetFuel(sentVeh, sentFuel)
	if not DoesEntityExist(sentVeh) then return end;
	if type(sentFuel) == 'number' and sentFuel >= 0 and sentFuel <= 100 then
		local fuel = sentFuel + 0.0
		Entity(sentVeh).state:set('fuel', fuel, true)
		SetVehicleFuelLevel(sentVeh, fuel)
	end
end

local function GetFuel(sentVeh)
	if not DoesEntityExist(sentVeh) then return end;
	return Entity(sentVeh).state.fuel or -1.0
end

local function doFuel(sentVeh)
	if DoesEntityExist(sentVeh) then
		local currFuel = GetFuel(sentVeh)
		if currFuel == -1.0 then
			TriggerServerEvent('erp-fuel:initFuel', VehToNet(sentVeh))
		elseif IsVehicleEngineOn(sentVeh) then
			SetFuel(sentVeh, currFuel - FuelUsage[Round(GetVehicleCurrentRpm(sentVeh), 1)] * (FuelClasses[GetVehicleClass(sentVeh)] or 1.0) / 10) -- From LegacyFuel
		end
	end
end

exports('SetFuel', SetFuel) -- exports['erp-fuel']:SetFuel(veh, fuel)
exports('GetFuel', GetFuel)-- exports['erp-fuel']:GetFuel(veh)

CreateThread(function()
	for i=1, #GasStations do
		local blip = AddBlipForCoord(GasStations[i])    
		SetBlipSprite(blip, 361)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 4)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Gas Station")
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip, true)
	end
	GasStations = nil
	while true do
		Wait(1000)
		local plyPed = PlayerPedId()
		local plyVeh = GetVehiclePedIsIn(plyPed, false)
		if plyVeh ~= 0 then
			local plySeat = GetPedInVehicleSeat(plyVeh, -1) == plyPed
			if plySeat then
				doFuel(plyVeh)
			end
		end
	end
end)