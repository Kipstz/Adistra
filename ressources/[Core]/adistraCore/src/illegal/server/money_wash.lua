RegisterServerEvent('adistraCore.washMoney')
AddEventHandler('adistraCore.washMoney', function(quantity)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local myMoney = tonumber(xPlayer['accounts'].getAccount('black_money').money)
    local qteToWash = tonumber(quantity)
    local distance = #(GetEntityCoords(GetPlayerPed(src)) - vector3(2434.0579, 4968.8311, 42.3476))

    if distance == nil or distance > 3 then
        DropPlayer(src, "Sécurité Server")
        return
    end
    if qteToWash and qteToWash > 0 and myMoney >= qteToWash then
        local cleanedMoney = qteToWash * 0.88 --number %
        xPlayer['accounts'].removeAccountMoney('black_money', qteToWash)
        xPlayer['accounts'].addAccountMoney('money', cleanedMoney)
        xPlayer.showNotification("~g~Vous avez reçu "..cleanedMoney.."$ !~s~")
    else
        xPlayer.showNotification("~r~Vous ne pouvez pas effectuer ceci !~s~")
    end
end)