
GoFast = {}

RegisterNetEvent('gofast:start')
AddEventHandler('gofast:start', function(configId)
    TriggerClientEvent("gofast:alert", -1, Config['gofast'].missions[configId].job)
end)

RegisterNetEvent('gofast:reward')
AddEventHandler('gofast:reward', function(configId)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local reward = tonumber(Config['gofast'].missions[configId].reward)

    xPlayer['accounts'].addAccountMoney('black_money', reward)
    xPlayer.showNotification("Merci pour la livraison. Tu as reçu ~r~"..reward.."$~s~ de récompense.")
end)