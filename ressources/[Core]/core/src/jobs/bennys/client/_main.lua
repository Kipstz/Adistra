BennysJob = {}
BennysJob.JobBlips = {}

BennysJob.inHarvest = false
BennysJob.inCraft = false

CreateThread(function()
    while true do
        wait = 1000

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'bennys' then
            for k,v in pairs(Config['job_bennys'].Points) do
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

function BennysJob:progress(msg, anim)
    VisualManager:helpNotify("[~r~E~s~] pour arrêter")
    Wait(1000)
    
    if BennysJob.inHarvest or BennysJob.inCraft then
        local plyPed = PlayerPedId()

        Wait(500)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
        ProgressBars:startUI(10000, msg)
    
        Wait(10000)
        ClearPedTasksImmediately(plyPed)
    
        BennysJob:progress(msg, anim)
    end
end

RegisterCommand('BennysJob:stop', function()
    if BennysJob.inHarvest or BennysJob.inCraft then
        Framework.ShowNotification("Arret en cours...")
        FreezeEntityPosition(PlayerPedId(), false)
    end
    if BennysJob.inHarvest then BennysJob.inHarvest = false; exports["ac"]:ExecuteServerEvent('BennysJob:stopHarvest') 
    elseif BennysJob.inCraft then BennysJob.inCraft = false; exports["ac"]:ExecuteServerEvent('BennysJob:stopCraft') 
    end
end)

RegisterKeyMapping('BennysJob:stop', "Arrêter l'action en cours (Mécano)", 'keyboard', 'E')
