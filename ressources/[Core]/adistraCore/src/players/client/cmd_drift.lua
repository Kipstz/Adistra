local drift_mode = false

RegisterCommand("drift", function()
    drift_mode = not drift_mode;
    local status = drift_mode and "~g~Activé~s~" or "~r~Désactivé~s~"

    if IsPedInAnyVehicle(PlayerPedId()) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
            Framework.ShowNotification("Mode-Drift " .. status .. " !")
            if not drift_mode then
                if (GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6) <= 90.0 then  
                    if IsControlPressed(1, 21) then
                        SetVehicleReduceGrip(GetVehiclePedIsIn(PlayerPedId()), true)
                    else
                        SetVehicleReduceGrip(GetVehiclePedIsIn(PlayerPedId()), false)
                    end
                end
            end
        end
    end
end)

RegisterKeyMapping('drift', "Activer le mod drift", 'keyboard', 'NUMPAD9')