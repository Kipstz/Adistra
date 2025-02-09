RegisterServerEvent("adistraCore.traitement")
AddEventHandler("adistraCore.traitement", function(item_requis, new_item, quantity)
    local src = source 
    local xPlayer = Framework.GetPlayerFromId(src)
    local quantity = tonumber(quantity)

    if new_item == nil or item_requis == nil then
        return
    end
    local item_requis_label = Framework.ITEMS:GetItemLabel(item_requis)

    if xPlayer['inventory'].getInventoryItem(item_requis).count >= quantity then
        if xPlayer['inventory'].canSwapItem(item_requis, quantity, new_item, quantity) then
            xPlayer['inventory'].removeInventoryItem(item_requis, quantity)
            xPlayer['inventory'].addInventoryItem(new_item, quantity)
            xPlayer.showNotification("~g~Vous avez traité ~b~"..quantity.."x ~o~"..item_requis_label.." ~s~!")
        else
            xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
        end
    else 
        xPlayer.showNotification("~r~Vous n'avez pas assez de "..item_requis_label.." pour traiter !~s~")
    end
end)