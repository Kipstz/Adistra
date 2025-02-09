function Assurances:convertName(name)
    for k,v in pairs(Config['assurances'].contrats) do
        if k == name then
            nameLabel = v.name
        end
    end
    return nameLabel
end

function Assurances:setNewContrat(id, plate)
    for k,v in pairs(Config['assurances'].contrats) do
        if k == id then
            args = {
                id = id,
                name = v.name,
                price = v.price,
                plate = plate
            }
        end
    end
    exports["ac"]:ExecuteServerEvent('assurances:newContrat', args)
end

function Assurances:claimVehicle(assuranceId, vehicle, spawn)
    Wait(500)
    Framework.TriggerServerCallback('assurances:check', function(can) 
        if can then
            if Framework.Game.IsSpawnPointClear(spawn.coords, 4.5) then
                Framework.Game.SpawnVehicle(vehicle.vehicle.model, vector3(spawn.coords.x, spawn.coords.y, spawn.coords.z), spawn.heading, function(veh)
                    Framework.Game.SetVehicleProperties(veh, vehicle.vehicle)
                    SetVehRadioStation(veh, 'OFF')
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    exports["ac"]:ExecuteServerEvent('assurances:vehicleSpawn', assuranceId)
                end)
            else
                Framework.ShowNotification("~r~Il n'y a pas asser de place !")
            end
        end
    end, assuranceId)
end