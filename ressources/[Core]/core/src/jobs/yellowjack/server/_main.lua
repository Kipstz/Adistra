

YellowJackJob = {}
YellowJackJob.inTimeout = false

RegisterServerEvent('YellowJackJob:annonce')
AddEventHandler('YellowJackJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not YellowJackJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "YellowJack", '~b~Annonce', annonce)
        end

        YellowJackJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

RegisterServerEvent('YellowJackJob:buy')
AddEventHandler('YellowJackJob:buy', function(item, qte)
    local xPlayer = Framework.GetPlayerFromId(source)

    if xPlayer['accounts'].getMoney() >= (item.price * qte) then
        if xPlayer['inventory'].canCarryItem(item.name, qte) then
            xPlayer['accounts'].removeMoney(item.price*qte)
            xPlayer['inventory'].addInventoryItem(item.name, qte)
    
            xPlayer.showNotification("Vous avez acheté ~b~"..qte.."x ~g~"..item.label.." ~s~!")
        else
            xPlayer.showNotification("~r~Vous n'avez pas asser de place dans votre Inventaire !")
        end
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterServerEvent('YellowJackJob:craft')
AddEventHandler('YellowJackJob:craft', function(needs, item)
    local xPlayer = Framework.GetPlayerFromId(source)

    for k,v in pairs(needs) do
        if xPlayer['inventory'].getInventoryItem(v).count < 1 then
            xPlayer.showNotification("~r~Vous n'avez pas les items nécessaire !")

            return
        end
    end

    local itemLabel = Framework.ITEMS:GetItemLabel(item)

    for k,v in pairs(needs) do
        xPlayer['inventory'].removeInventoryItem(v, 1)
    end

    if xPlayer['inventory'].canCarryItem(item, 1) then
        xPlayer['inventory'].addInventoryItem(item, 1)

        xPlayer.showNotification("~g~Vous avez fait ~b~1x ~g~"..itemLabel.." ~s~!")
    else
        for k,v in pairs(needs) do
            xPlayer['inventory'].addInventoryItem(v, 1)
        end

        xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
    end
end)

YellowJackJob.startTimeout = function(time)
    YellowJackJob.inTimeout = true
    
    SetTimeout(time, function()
        YellowJackJob.inTimeout = false
    end)
end