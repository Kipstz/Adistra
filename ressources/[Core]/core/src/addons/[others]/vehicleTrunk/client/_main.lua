
VehicleTrunk = {}

VehicleTrunk.selectedVeh = nil

RegisterCommand('vehicletrunk:open', function()
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)
    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

    if closestVeh ~= nil and IsPedOnFoot(plyPed) then
        if closestVeh ~= -1 and closestVehDistance < 3 and IsPedOnFoot(plyPed) then
            local class  = GetVehicleClass(closestVeh)

            if DoesVehicleHaveDoor(closestVeh, 5) or VehicleTrunk.bypass(GetEntityModel(closestVeh), class) or Config['vehicletrunk'].NoTrunkVehicles[GetEntityModel(closestVeh)] ~= nil then
                if GetVehicleDoorLockStatus(closestVeh) == 1 then
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    if closestPlayer ~= -1 and closestPlayerDistance < 10.5 then
                        Framework.ShowNotification("~r~Vous ne pouvez pas accéder au coffre avec une personne à proximité !.~s~")
                    else
                        VehicleTrunk.selectedVeh = closestVeh;
                        VehicleTrunk.OpenTrunkMenu(closestVeh, class)
                    end
                else
                    Framework.ShowNotification("Ce coffre est ~r~fermé~s~")
                end
            else
                Framework.ShowNotification("Ce ~r~véhicule~s~ ne possède pas de coffre.~s~")
            end
        else
            Framework.ShowNotification("~r~Aucun coffre à proximer.~s~")
        end
    end
end)

RegisterKeyMapping('vehicletrunk:open', "Acceder à un coffre de véhicule", 'keyboard', 'L')

VehicleTrunk.bypass = function(model, class)
    for k,v in pairs(Config['vehicletrunk'].bypassVehicles) do
        if model == v then
            return true
        end
    end

    for k,v in pairs(Config['vehicletrunk'].bypassClass) do
        if class == v then
            return true
        end
    end

    return false
end