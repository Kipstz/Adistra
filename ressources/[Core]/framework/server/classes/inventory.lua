
Framework.INVENTORY = {}
Framework.ITEMS = {}

Framework.ITEMS.UsableItemsCallbacks = {}
Framework.ITEMS.List = {}
Framework.INVENTORY.Pickups = {}
Framework.INVENTORY.PickupId = 0

-- CLASS --

function CreateExtendedInventory(playerId, characterId, inventory, weight)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.inventory = inventory;
    self.weight = weight;
    self.maxWeight = Config.MaxWeight;

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

    function self.getInventory(minimal)
		if minimal then
			local minimalInventory = {}

			for k, v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		end

		return self.inventory
	end

    function self.getInventoryItem(name, metadata)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end
	end

	function self.addInventoryItem(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = Framework.Math.Round(count)
			item.count = item.count + count
			self.weight = self.weight + (item.weight * count)

			self.triggerEvent('framework:addInventoryItem', item.name, item.count)
		end
	end

	function self.removeInventoryItem(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = Framework.Math.Round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount
				self.weight = self.weight - (item.weight * count)

				self.triggerEvent('framework:removeInventoryItem', item.name, item.count)
			end
		end
	end

	function self.setInventoryItem(name, count)
		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = Framework.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	function self.getWeight()
		return self.weight
	end

	function self.getMaxWeight()
		return self.maxWeight
	end

	function self.canCarryItem(name, count)
		local currentWeight, itemWeight = self.weight, Framework.ITEMS.List[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = Framework.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = Framework.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	function self.setMaxWeight(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('framework:setMaxWeight', self.maxWeight)
	end

    function self.hasItem(item)
		for k,v in ipairs(self.inventory) do
			if (v.name == name) and (v.count >= 1) then
				return v, v.count
			end
		end

		return false
	end

	return self
end

-- FUNCTIONS --

function Framework.ITEMS:GetItemsList()
	return Framework.ITEMS.List
end

function Framework.ITEMS:GetItemLabel(item)
	if Framework.ITEMS.List[item] then
		return Framework.ITEMS.List[item].label
	end
end

function Framework.ITEMS:GetUsableItems()
	local Usables = {}
	for k in pairs(Framework.ITEMS.UsableItemsCallbacks) do
		Usables[k] = true
	end
	return Usables
end

function Framework.ITEMS:RegisterUsableItem(item, cb)
	Framework.ITEMS.UsableItemsCallbacks[item] = cb
end

function Framework.ITEMS:CreateItem(item)
	MySQL.insert.await('INSERT INTO `items` (name, label, weight) VALUES (?, ?, ?)', {item.name, item.label, item.poids})
	Framework.ITEMS.List[item.name] = {
		label = item.label,
		weight = item.poids,
		canRemove = 1
	}
end

function Framework.ITEMS:RemoveItem(item)
	MySQL.update.await('DELETE FROM `items` WHERE name = ?', {item.name})
	Framework.ITEMS.List[item.name] = nil
end

function Framework.ITEMS:UseItem(source, item, ...)
	if Framework.ITEMS.List[item] then
		local itemCallback = Framework.ITEMS.UsableItemsCallbacks[item]
	
		if itemCallback then
			local success, result = pcall(itemCallback, source, item, ...)
			
			if not success then
				return result and print(result) or print(('[^3WARNING^7] An error occured when using item ^5"%s"^7! This was not caused by framework:'):format(item))
			end
		end
	else
		print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
	end
end

function Framework.INVENTORY:CreatePickup(type, name, count, label, playerId, components, tintIndex)
	print('CreatePickup:'..playerId)
	--[[
	local pickupId = (Framework.INVENTORY.PickupId == 65635 and 0 or Framework.INVENTORY.PickupId + 1)
	local xPlayer = Framework.GetPlayerFromId(playerId)
	local myCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
	local coords = vector3(myCoords.x, myCoords.y, myCoords.z)

	Framework.INVENTORY.Pickups[pickupId] = {
		type = type, name = name,
		count = count, label = label,
		coords = coords
	}

	if type == 'item_weapon' then
		Framework.INVENTORY.Pickups[pickupId].components = components
		Framework.INVENTORY.Pickups[pickupId].tintIndex = tintIndex
	end

	TriggerClientEvent('framework:createPickup', -1, pickupId, label, coords, type, name, components, tintIndex)
	Framework.INVENTORY.PickupId = pickupId
	]]
end

-- EVENTS --

RegisterNetEvent('framework:giveInventoryItem')
AddEventHandler('framework:giveInventoryItem', function(target, type, itemName, itemCount, source)
	local playerId = source
	local sourceXPlayer = Framework.GetPlayerFromId(playerId)
	local targetXPlayer = Framework.GetPlayerFromId(target)

	if type == 'item_standard' then
		local sourceItem = sourceXPlayer['inventory'].getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer['inventory'].canCarryItem(itemName, itemCount) then
				sourceXPlayer['inventory'].removeInventoryItem(itemName, itemCount)
				targetXPlayer['inventory'].addInventoryItem   (itemName, itemCount)

				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.name))
			end
		else
			sourceXPlayer.showNotification("~r~Quantité Invalide~s~")
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer['accounts'].getAccount(itemName).money >= itemCount then
			sourceXPlayer['accounts'].removeAccountMoney(itemName, itemCount)
			targetXPlayer['accounts'].addAccountMoney   (itemName, itemCount)

			sourceXPlayer.showNotification(_U('gave_account_money', Framework.Math.GroupDigits(itemCount), Config.Accounts[itemName], targetXPlayer.name))
			targetXPlayer.showNotification(_U('received_account_money', Framework.Math.GroupDigits(itemCount), Config.Accounts[itemName], sourceXPlayer.name))
		else
			sourceXPlayer.showNotification("~r~Montant Invalide~s~")
		end
	elseif type == 'item_weapon' then
		if sourceXPlayer['loadout'].hasWeapon(itemName) then
			local weaponLabel = Framework.GetWeaponLabel(itemName)

			if not targetXPlayer['loadout'].hasWeapon(itemName) then
				local _, weapon = sourceXPlayer['loadout'].getWeapon(itemName)
				local _, weaponObject = Framework.GetWeapon(itemName)
				itemCount = weapon.ammo

				sourceXPlayer['loadout'].removeWeapon(itemName)
				targetXPlayer['loadout'].addWeapon(itemName, itemCount)

				if weaponObject.ammo and itemCount > 0 then
					local ammoLabel = weaponObject.ammo.label
					sourceXPlayer.showNotification(_U('gave_weapon_withammo', weaponLabel, itemCount, ammoLabel, targetXPlayer.name))
					targetXPlayer.showNotification(_U('received_weapon_withammo', weaponLabel, itemCount, ammoLabel, sourceXPlayer.name))
				else
					sourceXPlayer.showNotification(_U('gave_weapon', weaponLabel, targetXPlayer.name))
					targetXPlayer.showNotification(_U('received_weapon', weaponLabel, sourceXPlayer.name))
				end
			else
				sourceXPlayer.showNotification(_U('gave_weapon_hasalready', targetXPlayer.name, weaponLabel))
				targetXPlayer.showNotification(_U('received_weapon_hasalready', sourceXPlayer.name, weaponLabel))
			end
		end
	elseif type == 'item_ammo' then
		if sourceXPlayer['loadout'].hasWeapon(itemName) then
			local weaponNum, weapon = sourceXPlayer['loadout'].getWeapon(itemName)

			if targetXPlayer['loadout'].hasWeapon(itemName) then
				local _, weaponObject = Framework.GetWeapon(itemName)

				if weaponObject.ammo then
					local ammoLabel = weaponObject.ammo.label

					if weapon.ammo >= itemCount then
						sourceXPlayer['loadout'].removeWeaponAmmo(itemName, itemCount)
						targetXPlayer['loadout'].addWeaponAmmo(itemName, itemCount)

						sourceXPlayer.showNotification(_U('gave_weapon_ammo', itemCount, ammoLabel, weapon.label, targetXPlayer.name))
						targetXPlayer.showNotification(_U('received_weapon_ammo', itemCount, ammoLabel, weapon.label, sourceXPlayer.name))
					end
				end
			else
				sourceXPlayer.showNotification(_U('gave_weapon_noweapon', targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_weapon_noweapon', sourceXPlayer.name, weapon.label))
			end
		end
	end
end)

RegisterNetEvent('framework:removeInventoryItem')
AddEventHandler('framework:removeInventoryItem', function(type, itemName, itemCount, source)
	local playerId = source
	local xPlayer = Framework.GetPlayerFromId(source)

	if type == 'item_standard' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification("~r~Quantité Invalide~s~")
		else
			local xItem = xPlayer['inventory'].getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification("~r~Quantité Invalide~s~")
			else
				xPlayer['inventory'].removeInventoryItem(itemName, itemCount)
				local pickupLabel = ('~y~%s~s~ [~b~%s~s~]'):format(xItem.label, itemCount)
				Framework.INVENTORY:CreatePickup('item_standard', itemName, itemCount, pickupLabel, playerId)
				xPlayer.showNotification("Vous avez jeter ~y~"..itemCount.."x ~b~"..xItem.label.."~s~")
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification("~r~Montant Invalide~s~")
		else
			local account = xPlayer['accounts'].getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification("~r~Montant Invalide~s~")
			else
				xPlayer['accounts'].removeAccountMoney(itemName, itemCount)
				local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(account.label, "~g~"..Framework.Math.GroupDigits(itemCount).."$~s~")
				Framework.INVENTORY:CreatePickup('item_account', itemName, itemCount, pickupLabel, playerId)
				xPlayer.showNotification("Vous avez jeter ~g~"..Framework.Math.GroupDigits(itemCount).."$~s~ ~b~"..string.lower(account.label).."~s~")
			end
		end
	elseif type == 'item_weapon' then
		itemName = string.upper(itemName)

		if xPlayer['loadout'].hasWeapon(itemName) then
			local _, weapon = xPlayer['loadout'].getWeapon(itemName)
			local _, weaponObject = Framework.GetWeapon(itemName)
			local components, pickupLabel = Framework.Table.Clone(weapon.components)
			xPlayer['loadout'].removeWeapon(itemName)

			if weaponObject.ammo and weapon.ammo > 0 then
				local ammoLabel = weaponObject.ammo.label
				pickupLabel = ('~y~%s~s~ [~g~%s~s~ %s]'):format(weapon.label, weapon.ammo, ammoLabel)
				xPlayer.showNotification("vous avez jeté ~y~1x~s~ ~b~"..weapon.label.."~s~ avec ~o~"..weapon.ammo.."x ~g~"..ammoLabel.."~s~")
			else
				pickupLabel = ('~y~%s~s~'):format(weapon.label)
				xPlayer.showNotification("Vous avez jeter x"..weapon.label.."~s~")
			end

			Framework.INVENTORY:CreatePickup('item_weapon', itemName, weapon.ammo, pickupLabel, playerId, components, weapon.tintIndex)
		end
	end
end)


RegisterNetEvent('framework:useItem')
AddEventHandler('framework:useItem', function(itemName, source)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	local count = xPlayer['inventory'].getInventoryItem(itemName).count

	if count > 0 then
		Framework.ITEMS:UseItem(src, itemName)
	else
		xPlayer.showNotification("~r~Action Impossible")
	end
end)

RegisterNetEvent('framework:onPickup')
AddEventHandler('framework:onPickup', function(pickupId)
	local pickup, xPlayer, success = Framework.INVENTORY.Pickups[pickupId], Framework.GetPlayerFromId(source)

	if pickup then
		if pickup.type == 'item_standard' then
			if xPlayer['inventory'].canCarryItem(pickup.name, pickup.count) then
				xPlayer['inventory'].addInventoryItem(pickup.name, pickup.count)
				success = true
			else
				xPlayer.showNotification("~r~Vous ne pouvez pas ramasser ça, votre inventaire est plein !~s~")
			end
		elseif pickup.type == 'item_account' then
			success = true
			xPlayer['accounts'].addAccountMoney(pickup.name, pickup.count)
		elseif pickup.type == 'item_weapon' then
			if xPlayer['loadout'].hasWeapon(pickup.name) then
				xPlayer.showNotification("~r~Vous avez déjà cette arme !~s~")
			else
				success = true
				xPlayer['loadout'].addWeapon(pickup.name, pickup.count)
				xPlayer['loadout'].setWeaponTint(pickup.name, pickup.tintIndex)

				for k,v in ipairs(pickup.components) do
					xPlayer['loadout'].addWeaponComponent(pickup.name, v)
				end
			end
		end

		if success then
			Framework.INVENTORY.Pickups[pickupId] = nil
			TriggerClientEvent('framework:removePickup', -1, pickupId)
		end
	end
end)