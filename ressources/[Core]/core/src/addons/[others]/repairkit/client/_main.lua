
RepairKit = {}

RegisterNetEvent('repairkit:useFixKit')
AddEventHandler('repairkit:useFixKit', function()
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)
    if IsPedSittingInAnyVehicle(plyPed) then
        Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cette action depuis un véhicule !")
        return
    end
    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)
    if closestVeh ~= -1 and closestVehDistance < 5.0 then
        TriggerServerEvent('repairkit:removeFixKit')
        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
        ProgressBars:startUI(15000, "Réparation...")
        Wait(15000)
        SetVehicleFixed(closestVeh)
        SetVehicleDeformationFixed(closestVeh)
        SetVehicleUndriveable(closestVeh, false)
        SetVehicleEngineOn(closestVeh, true, true)
        ClearPedTasksImmediately(plyPed)

        Framework.ShowNotification("~g~Véhicule Réparer !~s~")
    else
        Framework.ShowNotification("~r~Aucun véhicule à proximité !~s~")
    end
end)

RegisterNetEvent('repairkit:useCaroKit')
AddEventHandler('repairkit:useCaroKit', function()
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)
    if IsPedSittingInAnyVehicle(plyPed) then
        Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cette action depuis un véhicule !")
        return
    end
    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)
    if closestVeh ~= -1 and closestVehDistance < 5.0 then
        TriggerServerEvent('repairkit:removeCaroKit')
        TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
        ProgressBars:startUI(10000, "Nettoyage...")
        Wait(10000)
        SetVehicleDirtLevel(closestVeh, 0)
        ClearPedTasksImmediately(plyPed)

        Framework.ShowNotification("~g~Véhicule Nettoyé !~s~")
    else
        Framework.ShowNotification("~r~Aucun véhicule à proximité !~s~")
    end
end)

RegisterNetEvent('repairkit:useBlowPipe')
AddEventHandler('repairkit:useBlowPipe', function()
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)
    if IsPedSittingInAnyVehicle(plyPed) then
        Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cette action depuis un véhicule !")
        return
    end
    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)
    if closestVeh ~= -1 and closestVehDistance < 5.0 then
        TriggerServerEvent('repairkit:removeBlowPipe')
        TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(20000)
        ClearPedTasksImmediately(plyPed)

        SetVehicleDoorsLocked(closestVeh, 1)
        SetVehicleDoorsLockedForAllPlayers(closestVeh, false)
        Framework.ShowNotification("Véhicule ~g~dévérouillé~s~")
    else
        Framework.ShowNotification("~r~Aucun véhicule à proximité !~s~")
    end
end)