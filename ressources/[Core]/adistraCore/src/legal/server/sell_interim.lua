RegisterServerEvent("adistraCore.vente")
AddEventHandler("adistraCore.vente", function(item_requis, quantity, price)
    local src = source 
    local xPlayer = Framework.GetPlayerFromId(src)

    if item_requis == nil then
        return
    end
    if quantity == nil then
        return
    end
    local item_requis_label = Framework.ITEMS:GetItemLabel(item_requis)
    local price_final = tonumber(price * quantity)

    if xPlayer['inventory'].getInventoryItem(item_requis).count >= quantity then
        xPlayer['inventory'].removeInventoryItem(item_requis, quantity)
        xPlayer['accounts'].addAccountMoney('money', price_final)
        xPlayer.showNotification("~g~Vous avez vendu ~b~"..quantity.."x ~o~"..item_requis_label.." ~s~!")
    else 
        xPlayer.showNotification("~r~Vous n'avez pas assez de "..item_requis_label.." à vendre !~s~")
    end
end)