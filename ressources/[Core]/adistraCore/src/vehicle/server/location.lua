Framework.RegisterServerCallback("adistraCore.haveMoney", function(source, cb, price)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local price = tonumber(price)
    local moneyCash = tonumber(xPlayer['accounts'].getAccount('money').money)
    local moneyBank = tonumber(xPlayer['accounts'].getAccount('bank').money)

    if moneyCash >= tonumber(price) then
        xPlayer['accounts'].removeAccountMoney('money', price)
        xPlayer.showNotification("Vous avez payé ~g~"..price.."$~s~.")
        cb(true)
    elseif moneyBank >= tonumber(price) then
        xPlayer['accounts'].removeAccountMoney('bank', price)
        xPlayer.showNotification("Vous avez payé ~g~"..price.."$~s~.")
        cb(true)
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !")
        cb(false)
    end
end)