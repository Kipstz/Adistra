VigneronJob = {}

CreateThread(function()
    while true do
        wait = 1000

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'vigneron' then
            for k,v in pairs(Config['job_vigneron'].Points) do
                if k ~= 'deleters' then
                    local dist = Vdist(myCoords, v.pos)
                
                    if dist < 10 and dist > 1.5 then
                        wait = 1
    
                        DrawMarker(27, v.pos.x, v.pos.y, v.pos.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, false, true)
                    elseif dist < 1.5 then
                        wait = 1
    
                        Framework.ShowHelpNotification(v.msg)
    
                        if IsControlJustPressed(0, 51) then
                            v.action()
                        end
                    end
                else
                    for _,v2 in pairs(v.pos) do
                        local dist = Vdist(myCoords, v2)
                
                        if dist < 10 and dist > 1.5 then
                            wait = 1
        
                            DrawMarker(27, v2.x, v2.y, v2.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, false, true)
                        elseif dist < 1.5 then
                            wait = 1
        
                            Framework.ShowHelpNotification(v.msg)
        
                            if IsControlJustPressed(0, 51) then
                                v.action()
                            end
                        end
                    end
                end
            end
        end

        Wait(wait)
    end
end)

function VigneronJob:progress(msg, anim)
    VisualManager:helpNotify("[~r~E~s~] pour arrêter")
    Wait(1000)
    
    if VigneronJob.inCraft or VigneronJob.inHarvest or VigneronJob.inSell then
        local plyPed = PlayerPedId()

        Wait(500)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
        ProgressBars:startUI(5000, msg)
    
        Wait(5000)
        ClearPedTasksImmediately(plyPed)
    
        VigneronJob:progress(msg, anim)
    end
end

VigneronJob.inECooldown = false

RegisterCommand('vigneronjob:stop', function()
    if not VigneronJob.inECooldown then
        if VigneronJob.inHarvest or VigneronJob.inCraft or VigneronJob.inSell then
            VigneronJob.inECooldown = true
            Framework.ShowNotification("Arret en cours...")
            FreezeEntityPosition(PlayerPedId(), false)
        end
        
        if VigneronJob.inHarvest then VigneronJob.inHarvest = false; exports["ac"]:ExecuteServerEvent('VigneronJob:stopHarvest') 
        elseif VigneronJob.inCraft then VigneronJob.inCraft = false; exports["ac"]:ExecuteServerEvent('VigneronJob:stopCraft')
        elseif VigneronJob.inSell then VigneronJob.inSell = false; exports["ac"]:ExecuteServerEvent('VigneronJob:stopSell')
        end
    else
        Framework.ShowNotification("~r~Veuillez patienter 15 secondes avant de pouvoir arrêter.~s~")
        Wait(15000)
        VigneronJob.inECooldown = false
    end
end)

RegisterKeyMapping('vigneronjob:stop', "Arrêter l'action en cours (Vigneron)", 'keyboard', 'E')
