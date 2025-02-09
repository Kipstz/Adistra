
SwatJob = {}
SwatJob.inTimeout = false;

TriggerEvent("service:activateService", 'swat', 15)

RegisterServerEvent('SwatJob:annonce')
AddEventHandler('SwatJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not SwatJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "SWAT", '~b~Annonce', annonce)
        end

        SwatJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

SwatJob.startTimeout = function(time)
    SwatJob.inTimeout = true;
    
    SetTimeout(time, function()
        SwatJob.inTimeout = false;
    end)
end