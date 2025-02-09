
RegisterNetEvent('framework:addInventoryItem')
AddEventHandler('framework:addInventoryItem', function(item, count)
	for k,v in ipairs(Framework.PlayerData.inventory) do
		if v.name == item then
			-- Framework.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			Framework.PlayerData.inventory[k].count = count
			break
		end
	end
end)

RegisterNetEvent('framework:removeInventoryItem')
AddEventHandler('framework:removeInventoryItem', function(item, count)
	for k,v in ipairs(Framework.PlayerData.inventory) do
		if v.name == item then
			-- Framework.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			Framework.PlayerData.inventory[k].count = count
			break
		end
	end
end)

RegisterNetEvent('framework:setMaxWeight')
AddEventHandler('framework:setMaxWeight', function(newMaxWeight) Framework.PlayerData.maxWeight = newMaxWeight end)