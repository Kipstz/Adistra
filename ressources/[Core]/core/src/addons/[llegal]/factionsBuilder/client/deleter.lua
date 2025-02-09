
Factions.StoreVehicle = function(name, vehicle)
    local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)
    TriggerServerEvent('factions:storeVehicle', name, vehicleProps)

    Framework.Game.DeleteVehicle(vehicle)
end