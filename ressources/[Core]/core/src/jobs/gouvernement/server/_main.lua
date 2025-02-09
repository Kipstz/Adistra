
GouvernementJob = {}
GouvernementJob.inTimeout = false;

TriggerEvent("service:activateService", 'gouvernement', 15)

RegisterServerEvent('GouvernementJob:annonce')
AddEventHandler('GouvernementJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not GouvernementJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "GOUVERNEMENT", '~b~Annonce', annonce)
        end

        GouvernementJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

GouvernementJob.startTimeout = function(time)
    GouvernementJob.inTimeout = true;
    
    SetTimeout(time, function()
        GouvernementJob.inTimeout = false;
    end)
end