
FibJob = {}
FibJob.inTimeout = false;

TriggerEvent("service:activateService", 'fib', 15)

RegisterServerEvent('FibJob:annonce')
AddEventHandler('FibJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not FibJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "FIB", '~b~Annonce', annonce)
        end

        FibJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

FibJob.startTimeout = function(time)
    FibJob.inTimeout = true;
    
    SetTimeout(time, function()
        FibJob.inTimeout = false;
    end)
end