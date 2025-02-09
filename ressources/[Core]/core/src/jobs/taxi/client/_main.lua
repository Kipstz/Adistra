TaxiJob = {}

CreateThread(function()
    while true do
        wait = 1000

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'taxi' then
            for k,v in pairs(Config['job_taxi'].Points) do
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

TaxiJob.isInMission = false;
TaxiJob.missionStatus = '';

function TaxiJob:GetRandomInt(min, max, exclude)
    for i=1, 1000 do 
        local int = math.random(min, max)
        if exclude == nil or exclude ~= int then 
            return int
        end
    end
end

TaxiJob.blip = nil;

function TaxiJob:setDestination(coords)
    if TaxiJob.blip then 
        RemoveBlip(TaxiJob.blip)
    end
    TaxiJob.blip = AddBlipForCoord(coords)
    SetBlipSprite(TaxiJob.blip, 1)
    SetBlipDisplay(TaxiJob.blip, 4)
    SetBlipColour(TaxiJob.blip, 5)
    SetBlipScale(TaxiJob.blip, 0.75)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Destination Taxi")
    EndTextCommandSetBlipName(TaxiJob.blip)

    SetBlipRoute(TaxiJob.blip, true)
    SetBlipRouteColour(TaxiJob.blip, 5)
    return TaxiJob.blip
end

function TaxiJob:startMission()
    if not TaxiJob.isInMission then
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed) then
            local veh = GetVehiclePedIsIn(plyPed)
            local isDriver = (GetPedInVehicleSeat(veh, -1) == plyPed)
            local seatIsLibre = IsVehicleSeatFree(veh, -2)
    
            if isDriver then
                if seatIsLibre then
                    local can = false;
                    for k,v in pairs(Config['job_taxi'].Missions.wlVehicles) do
                        if GetEntityModel(veh) == v then can = true; end
                    end
        
                    if can then
                        RageUI.CloseAll()

                        TaxiJob.isInMission = true;
                        TaxiJob.missionStatus = 'pickup';
                        TaxiJob.ped = nil;
                        local from = TaxiJob:GetRandomInt(1, #Config['job_taxi'].Missions.localisations)
                        local to = TaxiJob:GetRandomInt(1, #Config['job_taxi'].Missions.localisations, from)
                        local coordsFrom = Config['job_taxi'].Missions.localisations[from];
                        local coordsTo = Config['job_taxi'].Missions.localisations[to];
                        local model = Config['job_taxi'].Missions.models[TaxiJob:GetRandomInt(1, #Config['job_taxi'].Missions.models)];
                        local enteringVehicle, exitingVehicle = false, false;

                        if TaxiJob.missionStatus == 'pickup' then
                            TaxiJob:setDestination(coordsFrom)
                            Framework.ShowNotification("Un itiniraire à été définit sur votre GPS.")

                            while TaxiJob.isInMission and TaxiJob.missionStatus == 'pickup' do
                                wait = 2000;
    
                                local myCoords = GetEntityCoords(plyPed)
                                local dist = Vdist(myCoords, coordsFrom)
    
                                if dist < 60 then
                                    if TaxiJob.ped == nil then
                                        enteringVehicle = false;
                                        TaxiJob.ped = EntityManager:createPed(model, coordsFrom, 0.0)
                                    else
                                        if IsEntityDead(TaxiJob.ped) then TaxiJob.missionStatus = 'fail'; end
    
                                        if dist < 10 and not enteringVehicle then
                                            enteringVehicle = true;
                                            if IsVehicleSeatFree(veh, 2) then
                                                TaskEnterVehicle(TaxiJob.ped, veh, -1, 2, 2.0, 1, 0)
                                            elseif IsVehicleSeatFree(veh, 1) then
                                                TaskEnterVehicle(TaxiJob.ped, veh, -1, 1, 2.0, 1, 0)
                                            else
                                                TaxiJob.missionStatus = 'fail';
                                            end
                                        elseif GetVehiclePedIsIn(TaxiJob.ped) == veh then
                                            TaxiJob.missionStatus = "dropoff";
                                        end
                                    end
                                    
                                else
                                    DeleteEntity(TaxiJob.ped)
                                    TaxiJob.ped = nil;
                                end
    
                                Wait(wait)
                            end
                        end

                        if TaxiJob.missionStatus == 'dropoff' then
                            TaxiJob:setDestination(coordsTo)
                            Framework.ShowNotification("Un nouvel itiniraire à été définit sur votre GPS.")

                            while TaxiJob.isInMission and TaxiJob.missionStatus == 'dropoff' do 
                                wait = 2000;

                                local myCoords = GetEntityCoords(plyPed)
                                local dist = Vdist(myCoords, coordsTo)
                    
                                if not DoesEntityExist(veh) or GetEntityHealth(veh) == 0 then 
                                    TaxiJob.missionStatus = 'fail';
                                end
                                if (not exitingVehicle and GetVehiclePedIsIn(TaxiJob.ped) ~= veh) or (not DoesEntityExist(TaxiJob.ped) or IsEntityDead(TaxiJob.ped)) then 
                                    TaxiJob.missionStatus = 'fail';
                                end

                                if dist < 5.0 and not exitingVehicle then 
                                    exitingVehicle = true
                                    TaskLeaveAnyVehicle(TaxiJob.ped, 1, 1)
                                elseif exitingVehicle and GetVehiclePedIsIn(TaxiJob.ped) ~= veh then
                                    TaxiJob.missionStatus = 'success';
                                end

                                Wait(wait)
                            end
                        end
                    
                        if TaxiJob.missionStatus == 'success' then
                            local dist = Vdist(coordsFrom, coordsTo)
                            TriggerServerEvent('TaxiJob:missionSuccess', dist)

                            TaskWanderStandard(TaxiJob.ped, 1, 1)
                            SetTimeout(5000, function()
                                DeleteEntity(TaxiJob.ped)
                            end)
                        elseif TaxiJob.missionStatus == 'fail' then
                            TaskWanderStandard(TaxiJob.ped, 1, 1)
                            SetTimeout(5000, function()
                                DeleteEntity(TaxiJob.ped)
                            end)

                            RemoveBlip(TaxiJob.blip)

                            Framework.ShowNotification("~r~La mission à échouer !~s~")
                        end

                    else
                        Framework.ShowNotification("~r~Vous ne pouvez pas lancer une mission avec ce véhicule !~s~")
                    end
                else
                    Framework.ShowNotification("~r~Aucun sièges disponible !~s~")
                end
            else
                Framework.ShowNotification("~r~Vous n'êtes pas conducteur du véhicule !~s~")
            end
        else
            Framework.ShowNotification("~r~Vous n'êtes pas dans un véhicule !~s~")
        end
    else
        Framework.ShowNotification("~r~Vous êtes déjà en mission !~s~")
    end
end

function TaxiJob:stopMission()
    if TaxiJob.isInMission and TaxiJob.missionStatus ~= '' then
        TaxiJob.isInMission = false;

        TaskWanderStandard(TaxiJob.ped, 1, 1)
        SetTimeout(5000, function()
            DeleteEntity(TaxiJob.ped)
        end)

        RemoveBlip(TaxiJob.blip)

        Framework.ShowNotification("~r~Vous avez abandonner la mission !~s~")
        RageUI.CloseAll()
    else
        Framework.ShowNotification("~r~Vous n'êtes pas en mission !~s~")
    end
end