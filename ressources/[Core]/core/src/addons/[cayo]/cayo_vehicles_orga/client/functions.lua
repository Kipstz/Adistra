
function Cayo_Vehicles_Orga:isJob()
    for k,v in pairs(Config['cayo_vda'].jobs) do
        if Framework.PlayerData.jobs['job2'].name == v then
            return true;
        end
    end
    return false;
end

function Cayo_Vehicles_Orga:spawnVehicle(model, coords, heading)
    Framework.Game.SpawnVehicle(model, coords, heading, function(vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        local plate = Concess:GenerateSocietyPlate('CAYO')
        SetVehicleNumberPlateText(vehicle, plate)
        exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', plate)
        RageUI.CloseAll()
    end)
end