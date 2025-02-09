
TriggerEvent("service:activateService", 'cookies', 15)

CookiesJob = {}
CookiesJob.inTimeout = false

RegisterServerEvent('CookiesJob:annonce')
AddEventHandler('CookiesJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not CookiesJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "Cookies & Co", '~b~Annonce', annonce)

        CookiesJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

CookiesJob.startTimeout = function(time)
    CookiesJob.inTimeout = true
    
    SetTimeout(time, function()
        CookiesJob.inTimeout = false
    end)
end
