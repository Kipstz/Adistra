TriggerEvent('framework:init', function(obj) Framework = obj end)

Framework.ITEMS:RegisterUsableItem('clip', function(src)
    local itemLabel = Framework.ITEMS:GetItemLabel('clip')

	TriggerClientEvent('adistraCore.useClip', src, "clip", itemLabel)
end)

RegisterServerEvent("adistraCore.deleteItem")
AddEventHandler("adistraCore.deleteItem", function()
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)

    xPlayer['inventory'].removeInventoryItem('clip', 1)
end)