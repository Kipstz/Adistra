
TriggerEvent("service:activateService", 'cayoauto', 15)

CayoAutoJob = {}
CayoAutoJob.inTimeout = false

CayoAutoJob.PlayersHarvesting = {}
CayoAutoJob.PlayersCrafting = {}

RegisterServerEvent('CayoAutoJob:annonce')
AddEventHandler('CayoAutoJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not CayoAutoJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "Cayo Perico Automobile", '~b~Annonce', annonce)

        CayoAutoJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

CayoAutoJob.startTimeout = function(time)
    CayoAutoJob.inTimeout = true
    
    SetTimeout(time, function()
        CayoAutoJob.inTimeout = false
    end)
end
