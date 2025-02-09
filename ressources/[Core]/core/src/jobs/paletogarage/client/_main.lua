PaletoGarageJob = {}
PaletoGarageJob.JobBlips = {}

PaletoGarageJob.inHarvest = false;
PaletoGarageJob.inCraft = false;

CreateThread(function()
    while true do
        wait = 1000

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'paletogarage' then
            for k,v in pairs(Config['job_paletogarage'].Points) do
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

function PaletoGarageJob:progress(msg, anim)
    VisualManager:helpNotify("[~r~E~s~] pour arrêter")
    Wait(1000)
    if PaletoGarageJob.inHarvest or PaletoGarageJob.inCraft then
        local plyPed = PlayerPedId();

        Wait(500)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
        ProgressBars:startUI(10000, msg)
    
        Wait(10000)
        ClearPedTasksImmediately(plyPed)
    
        PaletoGarageJob:progress(msg, anim)
    end
end

PaletoGarageJob.inECooldown = false;

RegisterCommand('paletogaragejob:stop', function()
    if not PaletoGarageJob.inECooldown then
        if PaletoGarageJob.inHarvest or PaletoGarageJob.inCraft then
            PaletoGarageJob.inECooldown = true
            Framework.ShowNotification("Arret en cours...")
            FreezeEntityPosition(PlayerPedId(), false)
        end
        if PaletoGarageJob.inHarvest then PaletoGarageJob.inHarvest = false; exports["ac"]:ExecuteServerEvent('PaletoGarageJob:stopHarvest') 
        elseif PaletoGarageJob.inCraft then PaletoGarageJob.inCraft = false; exports["ac"]:ExecuteServerEvent('PaletoGarageJob:stopCraft')  
        end
    else
        Framework.ShowNotification("~r~Veuillez patienter 15 secondes avant de pouvoir arrêter.~s~")
        Wait(15000)
        PaletoGarageJob.inECooldown = false;
    end
end)

RegisterKeyMapping('paletogaragejob:stop', "Arrêter l'action en cours (Paleto Garage)", 'keyboard', 'E')