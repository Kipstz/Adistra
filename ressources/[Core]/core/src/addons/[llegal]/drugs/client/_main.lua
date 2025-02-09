
Drugs = {}

CreateThread(function()
    for drugName,drugInfos in pairs(Config['drugs']) do
        for actionId, actionInfos in pairs(drugInfos) do
            ZoneManager:createZoneWithMarker(actionInfos.pos, 10, 4.5, {
                onPress = {control = 38, action = function(zone)
                    if not Drugs.inHarvest and not Drugs.inCraft and not Drugs.inSell then
                        actionInfos.action()
                    end
                end}
            })
        end
    end

    for drugName,drugInfos in pairs(Config['drugs']) do
        for actionId, actionInfos in pairs(drugInfos) do
            if actionId == 'sell' then
                local model = actionInfos.pedModel

                RequestModel(model)
                while not HasModelLoaded(model) do Wait(5) end
            
                local ped = CreatePed(4, model, actionInfos.pos, false, false)
            
                SetEntityHeading(ped, actionInfos.pedHeading)
                SetEntityAsMissionEntity(ped, true, true)
                SetPedHearingRange(ped, 0.0)
                SetPedSeeingRange(ped, 0.0)
                SetPedAlertness(ped, 0.0)
                SetPedFleeAttributes(ped, 0, 0)
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetPedCombatAttributes(ped, 46, true)
                SetPedFleeAttributes(ped, 0, 0)
                SetEntityInvincible(ped, true)
                Wait(5000)
                FreezeEntityPosition(ped, true)
            end
        end
    end
end)

function Drugs:progress(msg, anim)
    if Drugs.inHarvest or Drugs.inCraft or Drugs.inSell then
        VisualManager:helpNotify("[~r~E~s~] pour arrêter")
        local plyPed = PlayerPedId();

        Wait(500)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
        ProgressBars:startUI(10000, msg)
    
        Wait(10000)
        ClearPedTasksImmediately(plyPed)
    
        Drugs:progress(msg, anim)
    end
end

Drugs.inECooldown = false

RegisterCommand('drugs:stop', function()
    if Drugs.inHarvest or Drugs.inCraft or Drugs.inSell then
        if Drugs.inHarvest then Drugs.inHarvest = false; exports["ac"]:ExecuteServerEvent('drugs:stopHarvest') 
        elseif Drugs.inCraft then Drugs.inCraft = false; exports["ac"]:ExecuteServerEvent('drugs:stopCraft')  
        elseif Drugs.inSell then Drugs.inSell = false; exports["ac"]:ExecuteServerEvent('drugs:stopSell') 
        end
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)

RegisterKeyMapping('drugs:stop', "Arrêter l'action en cours (Drogues)", 'keyboard', 'E')