
JobCenter = {}

CreateThread(function()
    local CenterJob = Config['jobcenter']['center'];
    EntityManager:createPed(CenterJob.pedModel, CenterJob.pos, CenterJob.pedHeading)
    ZoneManager:createZoneWithMarker(CenterJob.pos, 10, 1.5, {
        onPress = {control = 38, action = function(zone)
            JobCenter:OpenMenu()
        end}
    })
end)

function JobCenter:SpawnVehicule(job, vehicleName)
    local c = Config['jobcenter']['points'][job]['base']['garage']
    if Framework.Game.IsSpawnPointClear(c.spawn, 5.0) then
        Framework.Game.SpawnVehicle(vehicleName, c.spawn, c.heading, function(vehicle) 
            local newPlate = Concess:GenerateSocietyPlate('MINE')
            SetVehicleNumberPlateText(vehicle, newPlate)
            exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)

            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            RageUI.CloseAll()
        end)

        Framework.ShowNotification("~g~Véhicule Spawn !~s~")
    else
        Framework.ShowNotification("~r~Aucune place disponible !~s~")
    end
end

function JobCenter:Service(service, job)
    if service then
        for k,v in pairs(Config['jobcenter']['points']) do
            if v.jobRequired == job then
                BlipManager:addBlip('jobCenterHarvest_'..k, v['harvest']['blip'].pos, v['harvest']['blip'].sprite, v['harvest']['blip'].color, v['harvest']['blip'].label, 0.7, true)
                BlipManager:addBlip('jobCenterTreatment_'..k, v['treatment']['blip'].pos, v['treatment']['blip'].sprite, v['treatment']['blip'].color, v['treatment']['blip'].label, 0.7, true)
                BlipManager:addBlip('jobCenterCraft_'..k, v['craft']['blip'].pos, v['craft']['blip'].sprite, v['craft']['blip'].color, v['craft']['blip'].label, 0.7, true)
                BlipManager:addBlip('jobCenterSell_'..k, v['sell']['blip'].pos, v['sell']['blip'].sprite, v['sell']['blip'].color, v['sell']['blip'].label, 0.7, true)
            end
        end
    else
        for k,v in pairs(Config['jobcenter']['points']) do
            if v.jobRequired == job then
                BlipManager:removeBlip('jobCenterHarvest_'..k)
                BlipManager:removeBlip('jobCenterTreatment_'..k)
                BlipManager:removeBlip('jobCenterCraft_'..k)
                BlipManager:removeBlip('jobCenterSell_'..k)
            end
        end
    end
end

function JobCenter:progress(msg, anim)
    VisualManager:helpNotify("[~r~E~s~] pour arrêter")
    Wait(1000)
    if JobCenter.inHarvest or JobCenter.inTreatment or JobCenter.inCraft or JobCenter.inSell then
        local plyPed = PlayerPedId();

        Wait(500)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, anim, 0, true)
    
        ProgressBars:startUI(10000, msg)
    
        Wait(10000)
        ClearPedTasksImmediately(plyPed)
    
        JobCenter:progress(msg, anim)
    end
end

JobCenter.inECooldown = false

RegisterCommand('jobcenter:stop', function()
    if not JobCenter.inECooldown then
        if JobCenter.inHarvest or JobCenter.inTreatment or JobCenter.inCraft or JobCenter.inSell then
            JobCenter.inECooldown = true
            Framework.ShowNotification("Arret en cours...")
            FreezeEntityPosition(PlayerPedId(), false)
        end
        if JobCenter.inHarvest then JobCenter.inHarvest = false; exports["ac"]:ExecuteServerEvent('jobcenter:stopHarvest') 
        elseif JobCenter.inTreatment then JobCenter.inTreatment = false; exports["ac"]:ExecuteServerEvent('jobcenter:stopTreatment') 
        elseif JobCenter.inCraft then JobCenter.inCraft = false; exports["ac"]:ExecuteServerEvent('jobcenter:stopCraft')  
        elseif JobCenter.inSell then JobCenter.inSell = false; exports["ac"]:ExecuteServerEvent('jobcenter:stopSell') 
        end
    else
        Framework.ShowNotification("~r~Veuillez patienter 15 secondes avant de pouvoir arrêter.~s~")
        Wait(15000)
        JobCenter.inECooldown = false
    end
end)

RegisterKeyMapping('jobcenter:stop', "Arrêter l'action en cours (Pole-Emploi)", 'keyboard', 'E')
