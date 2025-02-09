MecanoJob = {}
MecanoJob.JobBlips = {}

MecanoJob.inHarvest = false;
MecanoJob.inCraft = false;

CreateThread(function()
    while true do
        wait = 1000

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'mecano' then
            for k,v in pairs(Config['job_mecano'].Points) do
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

function MecanoJob:progress(msg, anim)
    VisualManager:helpNotify("[~r~E~s~] pour arrêter")
    Wait(1000)
    if MecanoJob.inHarvest or MecanoJob.inCraft then
        local plyPed = PlayerPedId();

        Wait(500)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
        ProgressBars:startUI(10000, msg)
    
        Wait(10000)
        ClearPedTasksImmediately(plyPed)
    
        MecanoJob:progress(msg, anim)
    end
end

MecanoJob.inECooldown = false;

RegisterCommand('mecanojob:stop', function()
    if not MecanoJob.inECooldown then
        if MecanoJob.inHarvest or MecanoJob.inCraft then
            MecanoJob.inECooldown = true
            Framework.ShowNotification("Arret en cours...")
            FreezeEntityPosition(PlayerPedId(), false)
        end
        if MecanoJob.inHarvest then MecanoJob.inHarvest = false; exports["ac"]:ExecuteServerEvent('MecanoJob:stopHarvest') 
        elseif MecanoJob.inCraft then MecanoJob.inCraft = false; exports["ac"]:ExecuteServerEvent('MecanoJob:stopCraft')  
        end
    else
        Framework.ShowNotification("~r~Veuillez patienter 15 secondes avant de pouvoir arrêter.~s~")
        Wait(15000)
        MecanoJob.inECooldown = false;
    end
end)

RegisterKeyMapping('mecanojob:stop', "Arrêter l'action en cours (Mécano)", 'keyboard', 'E')