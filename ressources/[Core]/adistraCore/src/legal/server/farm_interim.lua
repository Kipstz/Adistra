RegisterServerEvent("adistraCore.recolte")
AddEventHandler("adistraCore.recolte", function(item)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local itemCount = math.random(1, 3)

    if item == nil then
        return
    end
    local itemLabel = Framework.ITEMS:GetItemLabel(item);
    if xPlayer['inventory'].canCarryItem(item, itemCount) then
        xPlayer['inventory'].addInventoryItem(item, itemCount)
        xPlayer.showNotification("~g~Vous avez récolté ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
    else 
        xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
    end
end)