
function Cayo_Locations:spawnVehicle(model, coords, heading)
    Framework.Game.SpawnVehicle(model, coords, heading, function(vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        local plate = Concess:GenerateSocietyPlate('CLOC')
        SetVehicleNumberPlateText(vehicle, plate)
        exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', plate)
        RageUI.CloseAll()
    end)
end