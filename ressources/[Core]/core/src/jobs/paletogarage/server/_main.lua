
TriggerEvent("service:activateService", 'paletogarage', 15)

PaletoGarageJob = {}
PaletoGarageJob.inTimeout = false

RegisterServerEvent('PaletoGarageJob:annonce')
AddEventHandler('PaletoGarageJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not PaletoGarageJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "Paleto Garage", '~b~Annonce', annonce)

        PaletoGarageJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

PaletoGarageJob.startTimeout = function(time)
    PaletoGarageJob.inTimeout = true
    
    SetTimeout(time, function()
        PaletoGarageJob.inTimeout = false
    end)
end
