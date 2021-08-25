RegisterNetEvent('erp-fuel:initFuel')
AddEventHandler('erp-fuel:initFuel', function(sentVeh)
	Entity(NetworkGetEntityFromNetworkId(sentVeh)).state.fuel = math.random(40, 60)
end)

AddEventHandler('erp-fuel:setFuel', function(sentVeh, sentFuel)
	if type(sentFuel) == 'number' and sentFuel >= 0 and sentFuel <= 100 then
		if DoesEntityExist(sentVeh) then
			Entity(sentVeh).state.fuel = sentFuel
		else
			Entity(NetworkGetEntityFromNetworkId(sentVeh)).state.fuel = sentFuel
		end
	end
end)

local function GetFuel(sentVeh)
	if DoesEntityExist(sentVeh) then
		return Entity(sentVeh).state.fuel
	else
		return Entity(NetworkGetEntityFromNetworkId(sentVeh)).state.fuel
	end
end

exports('GetFuel', GetFuel) -- exports['erp-fuel']:GetFuel(veh)

--[[RegisterCommand("setfuel", function(source, args, rawCommand)
 TriggerEvent('erp-fuel:setFuel', GetVehiclePedIsIn(GetPlayerPed(source)), tonumber(args[1]))
end, false)]]