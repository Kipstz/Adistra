
TriggerEvent("service:activateService", 'mecano', 15)

MecanoJob = {}
MecanoJob.inTimeout = false

RegisterServerEvent('MecanoJob:annonce')
AddEventHandler('MecanoJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not MecanoJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "LS Custom", '~b~Annonce', annonce)

        MecanoJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

MecanoJob.startTimeout = function(time)
    MecanoJob.inTimeout = true
    
    SetTimeout(time, function()
        MecanoJob.inTimeout = false
    end)
end
