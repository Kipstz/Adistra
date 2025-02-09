Framework.ITEMS:RegisterUsableItem('gpb', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)
    local itemLabel = Framework.ITEMS:GetItemLabel('gpb')

	xPlayer['inventory'].removeInventoryItem('gpb', 1)
	TriggerClientEvent('adistraCore.useGPB', src, "gpb", itemLabel)
end)

Framework.ITEMS:RegisterUsableItem('medikit', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)
    local itemLabel = Framework.ITEMS:GetItemLabel('medikit')

	xPlayer['inventory'].removeInventoryItem('medikit', 1)
	TriggerClientEvent('adistraCore.useMediKit', src)
end)

Framework.ITEMS:RegisterUsableItem('bandage', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)
    local itemLabel = Framework.ITEMS:GetItemLabel('bandage')

	xPlayer['inventory'].removeInventoryItem('bandage', 1)
	TriggerClientEvent('adistraCore.useBandage', src)
end)