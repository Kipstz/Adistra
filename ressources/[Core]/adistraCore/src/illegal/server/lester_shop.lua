RegisterNetEvent('adistraCore.actionMenu')
AddEventHandler('adistraCore.actionMenu', function(item, quantity, action)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local distance = #(GetEntityCoords(GetPlayerPed(src)) - vector3(707.8, -965.2, 30.4))
    local price = tonumber(item.price * quantity)

    if distance == nil or distance > 3 then
        DropPlayer(src, "Sécurité Server")
        return
    end
    if action == "buy" then 
        local myMoney = tonumber(xPlayer['accounts'].getAccount('black_money').money)
        if myMoney and myMoney >= price then 
            xPlayer['inventory'].addInventoryItem(item.name, quantity)
            xPlayer['accounts'].removeAccountMoney('black_money', price)
            xPlayer.showNotification("~g~Vous avez acheté "..quantity.."x "..item.label.." pour "..price.."$ !~s~")
        else 
            xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !~s~")
        end
    elseif action == "sell" then 
        local myItems = tonumber(xPlayer['inventory'].getInventoryItem(item.name).count)
        if myItems and myItems >= quantity then 
            xPlayer['inventory'].removeInventoryItem(item.name, quantity)
            xPlayer['accounts'].addAccountMoney('black_money', price)
            xPlayer.showNotification("~g~Vous avez vendu "..quantity.."x "..item.label.." pour "..price.."$ !~s~")
        else 
            xPlayer.showNotification("~r~Vous n'avez pas cette quantité sur vous !~s~")
        end
    end
end)