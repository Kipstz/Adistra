
TriggerEvent("service:activateService", 'journalist', 15)

JournalisteJob = {}

RegisterServerEvent('JournalisteJob:annonce')
AddEventHandler('JournalisteJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not JournalisteJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "Weazel-News", '~b~Annonce', annonce)
        end

        JournalisteJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

JournalisteJob.startTimeout = function(time)
    JournalisteJob.inTimeout = true
    
    SetTimeout(time, function()
        JournalisteJob.inTimeout = false
    end)
end

RegisterCommand("cam", function(source, args, raw)
    local src = source
    if src ~= -1 then
        TriggerClientEvent("JournalisteJob:toggleCam", src)
    end
end)

RegisterCommand("bmic", function(source, args, raw)
    local src = source
    if src ~= -1 then
        TriggerClientEvent("JournalisteJob:toggleBMic", src)
    end
end)

RegisterCommand("mic", function(source, args, raw)
    local src = source
    if src ~= -1 then
        TriggerClientEvent("JournalisteJob:toggleMic", src)
    end
end)