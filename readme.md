# erp-fuel
A fuel system that uses state bags to sync fuel between all clients. If you have any questions, feel free to open an issue.

# Onesync Required
This script requires Onesync in order to work.

# Usage
You can manage fuel using the server-side event or client-side exports.

## Setting Fuel

**Server Usage:**
```
local plyPed = GetPlayerPed(source)
local plyVeh = GetVehiclePedIsIn(plyPed)
TriggerEvent('erp-fuel:setFuel', plyVeh, 50)
```
**Client Usage:**
```
local plyPed = PlayerPedId()
local plyVeh = GetVehiclePedIsIn(plyPed)
exports['erp-fuel']:SetFuel(plyVeh, 50)
```

## Getting Fuel

**Server Usage:**
```
local plyPed = GetPlayerPed(source)
local plyVeh = GetVehiclePedIsIn(plyPed)
local plyFuel = exports['erp-fuel']:GetFuel(plyVeh)
```
**Client Usage:**
```
local plyPed = PlayerPedId()
local plyVeh = GetVehiclePedIsIn(plyPed)
local plyFuel = exports['erp-fuel']:GetFuel(plyVeh)
```