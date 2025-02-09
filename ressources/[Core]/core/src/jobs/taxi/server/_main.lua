
TriggerEvent("service:activateService", 'taxi', 15)

TaxiJob = {}

RegisterServerEvent('TaxiJob:annonce')
AddEventHandler('TaxiJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not TaxiJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "Taxi", '~b~Annonce', annonce)
        end

        TaxiJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

TaxiJob.startTimeout = function(time)
    TaxiJob.inTimeout = true
    
    SetTimeout(time, function()
        TaxiJob.inTimeout = false
    end)
end

RegisterServerEvent('TaxiJob:missionSuccess')
AddEventHandler('TaxiJob:missionSuccess', function(dist)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['jobs'] ~= nil and xPlayer['jobs'].job.name == 'taxi' then
        local grade = xPlayer['jobs'].job.grade;
        local rewards = Config['job_taxi'].Missions.rewards[grade]
        local amount = math.random(rewards.min, rewards.max)
        local multi = rewards.kmMultiplier * (dist / 1000)
        amount = math.ceil(amount * multi)
        
        xPlayer['accounts'].addMoney(tonumber(amount/2))
        TriggerEvent('bossManagement:depositMoneybyOther', 'taxi', tonumber(amount/2))
        xPlayer.showNotification("La société et vous avez chacun reçu ~g~"..(amount/2).."$ ~s~!")
    end
end)