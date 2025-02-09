
TriggerEvent("service:activateService", 'burger', 15)

BurgerShotJob = {}
BurgerShotJob.inTimeout = false

RegisterServerEvent('BurgerShotJob:annonce')
AddEventHandler('BurgerShotJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not BurgerShotJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "Burger Shot", '~b~Annonce', annonce)

        BurgerShotJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

BurgerShotJob.startTimeout = function(time)
    BurgerShotJob.inTimeout = true
    
    SetTimeout(time, function()
        BurgerShotJob.inTimeout = false
    end)
end
