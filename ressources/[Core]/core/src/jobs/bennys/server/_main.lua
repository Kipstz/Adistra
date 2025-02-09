
TriggerEvent("service:activateService", 'bennys', 15)

BennysJob = {}
BennysJob.inTimeout = false

BennysJob.PlayersHarvesting = {}
BennysJob.PlayersCrafting = {}

RegisterServerEvent('BennysJob:annonce')
AddEventHandler('BennysJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not BennysJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "Benny's", '~b~Annonce', annonce)

        BennysJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

BennysJob.startTimeout = function(time)
    BennysJob.inTimeout = true
    
    SetTimeout(time, function()
        BennysJob.inTimeout = false
    end)
end
