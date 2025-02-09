
RegisterNetEvent('banques:deposit')
AddEventHandler('banques:deposit', function(qte)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if xPlayer['accounts'].getMoney() >= qte then
        xPlayer['accounts'].removeMoney(qte)
        xPlayer['accounts'].addAccountMoney('bank', qte)
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterNetEvent('banques:remove')
AddEventHandler('banques:remove', function(qte)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if xPlayer['accounts'].getAccount('bank').money >= qte then
        xPlayer['accounts'].removeAccountMoney('bank', qte)
        xPlayer['accounts'].addMoney(qte)
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)