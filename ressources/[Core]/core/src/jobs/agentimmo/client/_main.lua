Agent_ImmoJob = {}

CreateThread(function()
    while true do
        wait = 1000

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        for k,v in pairs(Config['job_agentimmo'].Points) do
            if k ~= 'enter' and k ~= 'exit' then
                if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'agentimmo' then
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
                end
            else
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
            end
        end

        Wait(wait)
    end
end)

function Agent_ImmoJob:enter(coords)
    SetEntityCoords(PlayerPedId(), coords)
end

function Agent_ImmoJob:exit(coords)
    SetEntityCoords(PlayerPedId(), coords)
end

function Agent_ImmoJob:tpVisualisation(ped, coords)
    if coords ~= nil then
        while Vdist(GetEntityCoords(ped), coords) > 5 do
            SetEntityCoords(ped, coords)
    
            Wait(1)
        end
    end
end