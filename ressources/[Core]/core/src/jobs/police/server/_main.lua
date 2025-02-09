
PoliceJob = {}
PoliceJob.inTimeout = false;

TriggerEvent("service:activateService", 'police', 15)

RegisterServerEvent('PoliceJob:annonce')
AddEventHandler('PoliceJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not PoliceJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "LSPD", '~b~Annonce', annonce)
        end

        PoliceJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

PoliceJob.startTimeout = function(time)
    PoliceJob.inTimeout = true;
    
    SetTimeout(time, function()
        PoliceJob.inTimeout = false;
    end)
end