
VehicleTrunk = {}

MySQL.ready(function()
    MySQL.query("DELETE FROM trunk_inventory WHERE owned = 0")
end)

VehicleTrunk.GetOwnedVehicule = function(plate)
    local found = nil;
    
    if found == nil then
        MySQL.query("SELECT * FROM character_vehicles WHERE plate = ?", { plate }, function(result)
            if next(result) then found = true else found = false end
        end)
    end

    while found == nil do Wait(1) end
    return found;
end

VehicleTrunk.GetItemWeight = function(item)
    local itemWeight = 0;
    if item ~= nil then
        itemWeight = 1.0;
        for k,v in pairs(Framework.ITEMS:GetItemsList()) do
            if k == item then itemWeight = v.weight end
        end
    end
    return itemWeight;
end

VehicleTrunk.GetWeaponWeight = function(weapon)
    local weaponWeight = 0;
    if weapon ~= nil and Config['vehicletrunk'].weapons[weapon] ~= nil then weaponWeight = Config['vehicletrunk'].weapons[weapon] end
    return weaponWeight;
end

VehicleTrunk.GetInventoryWeight = function(inventory)
    local weight = 0;
    local itemWeight = 0;
    if inventory ~= nil then
        for i = 1, #inventory, 1 do
            if inventory[i] ~= nil then
                itemWeight = VehicleTrunk.GetItemWeight(inventory[i].name)
                if itemWeight == nil then itemWeight = 1.0 end
                weight = weight + itemWeight * inventory[i].count or 1
            end
        end
    end
    return weight;
end

VehicleTrunk.GetLoadoutWeight = function(loadout)
    local weight = 0;
    local weaponWeight = 0;
    if loadout ~= nil then
        for i=1, #loadout, 1 do
            if loadout[i] ~= nil then
                weaponWeight = 1.0;
                if Config['vehicletrunk'].weapons[loadout[i].name] ~= nil then weaponWeight = Config['vehicletrunk'].weapons[loadout[i].name] end
                weight = weight + weaponWeight * loadout[i].count or 1
            end
        end
    end
    return weight;
end

VehicleTrunk.GetTotalCoffreWeight = function(plate)
    local total = nil;
	local result = MySQL.prepare.await("SELECT * FROM trunk_inventory WHERE plate = ?", {plate})

	if result ~= nil then
		local data = json.decode(result['data'])

		local W_inventory  = VehicleTrunk.GetInventoryWeight(data.items)
		local W_loadout    = VehicleTrunk.GetLoadoutWeight(data.weapons)
		local W_Money      = 0
		local W_BMoney     = 0
	
		local moneyAccount = data.accounts['money']
		if moneyAccount ~= 0 then W_Money = moneyAccount /100000 end
			
		local blackAccount = data.accounts['black_money']
		if blackAccount ~= 0 then W_BMoney = blackAccount /100000 end
	
		total = tonumber(W_inventory + W_loadout + W_Money + W_BMoney)
	
		while total == nil do Wait(100) end
	
		return total;
	else
		return 0;
	end
end

Framework.RegisterServerCallback('vehicletrunk:getTrunkInventory', function(src, cb, plate)
	local result = MySQL.prepare.await("SELECT * FROM trunk_inventory WHERE plate = ?", {plate})
	if result ~= nil then
		local data = json.decode(result['data'])
		Wait(750)
		cb({
			accounts = data.accounts,
			items = data.items,
			weapons = data.weapons,
			weight = Framework.Math.Round(VehicleTrunk.GetTotalCoffreWeight(plate), 1),
			plate = result.plate
		})
	else
		cb(nil)
	end
end)

RegisterNetEvent('vehicletrunk:deposit')
AddEventHandler('vehicletrunk:deposit', function(type, plate, item, qte, MaxWeight)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	local owned = VehicleTrunk.GetOwnedVehicule(plate)
	local coffreWeight = VehicleTrunk.GetTotalCoffreWeight(plate)

	local can, found = false, false;
	local message = "(Coffre véhicule) Invalide";

	local trunkData = {
		accounts = { money = 0, black_money = 0 },
		items = {},
		loadout = {}
	}
	local result = MySQL.prepare.await("SELECT * FROM trunk_inventory WHERE plate = ?", {plate})

	Wait(750)

	if result ~= nil then trunkData = json.decode(result['data']) end

	if result ~= nil then
		if type == 'item_accounts' then
			if (coffreWeight + (Framework.Math.Round(qte/100000, 1))) <= MaxWeight then
				if tonumber(xPlayer['accounts'].getAccount(item.name).money) >= tonumber(qte) then
					for k,v in pairs(trunkData.accounts) do
						if k == item.name then
							trunkData.accounts[k] = (trunkData.accounts[k] + qte)
		
							xPlayer['accounts'].removeAccountMoney(item.name, qte)
							xPlayer.showNotification("Vous avez déposer ~g~"..qte.."$~s~ !")
							message = ("(Coffre Véhicule) **%s** à déposer **%s**$ **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
							can, found = true, true;
						end
					end
				end
			else
				can, found = 'maxWeight', true;
			end
	    elseif type == 'item_standard' then
			if coffreWeight + VehicleTrunk.GetItemWeight(item.name)*qte <= MaxWeight then
				for k,v in pairs(trunkData.items) do
					if v.name == item.name then
						if tonumber(xPlayer['inventory'].getInventoryItem(item.name).count) >= tonumber(qte) then
							trunkData.items[k].count = (trunkData.items[k].count + qte)
	
							xPlayer['inventory'].removeInventoryItem(item.name, qte)
							xPlayer.showNotification("Vous avez déposer ~b~"..qte.."x ~g~"..item.label.."~s~ !")
							message = ("(Coffre Véhicule) **%s** à déposer **%s**x **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
							can, found = true, true;
						end
					end
				end
			else
				can, found = 'maxWeight', true;
			end
		elseif type == 'item_weapon' then
			if coffreWeight + VehicleTrunk.GetWeaponWeight(item.name) <= MaxWeight then
				for k,v in pairs(trunkData.weapons) do
					if v.name == item.name then
						if xPlayer['loadout'].hasWeapon(item.name) then
							trunkData.weapons[k].count = (trunkData.weapons[k].count + 1)
	
							xPlayer['loadout'].removeWeapon(item.name)
							xPlayer.showNotification("Vous avez déposer ~g~"..item.label.."~s~ !")
							message = ("(Coffre Véhicule) **%s** à déposer **%s**, plaque **%s**"):format(GetPlayerName(src), item.label, plate)
							can, found = true, true;
						end
					end
				end
			else
				can, found = 'maxWeight', true;
			end
		end

		if can and can ~= 'maxWeight' then
			MySQL.query("UPDATE trunk_inventory SET data = ? WHERE plate = ?", {json.encode(trunkData), plate})
			exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
		end
	else
		trunkData = {
			accounts = { money = 0, black_money = 0 },
			items = {},
			weapons = {}
		}

		if type == 'item_accounts' then
			if coffreWeight + (Framework.Math.Round(qte/100000, 1)) <= MaxWeight then
				if tonumber(xPlayer['accounts'].getAccount(item.name).money) >= tonumber(qte) then
					trunkData.accounts[item.name] = qte
	
					xPlayer['accounts'].removeAccountMoney(item.name, qte)
					xPlayer.showNotification("Vous avez déposer ~g~"..qte.."$~s~ !")
					message = ("(Coffre Véhicule) **%s** à déposer **%s**$ **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
					can, found = true, true;
				end
			else
				can, found = 'maxWeight', true;
			end
	    elseif type == 'item_standard' then
			if coffreWeight + VehicleTrunk.GetItemWeight(item.name)*qte <= MaxWeight then
				if tonumber(xPlayer['inventory'].getInventoryItem(item.name).count) >= tonumber(qte) then
					table.insert(trunkData.items, {
						name = item.name,
						label = item.label,
						count = qte
					})
	
					xPlayer['inventory'].removeInventoryItem(item.name, qte)
					xPlayer.showNotification("Vous avez déposer ~b~"..qte.."x ~g~"..item.label.."~s~ !")
					message = ("(Coffre Véhicule) **%s** à déposer **%s**x **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
					can, found = true, true;
				end
			else
				can, found = 'maxWeight', true;
			end
		elseif type == 'item_weapon' then
			if xPlayer['loadout'].hasWeapon(item.name) then
				if coffreWeight + VehicleTrunk.GetWeaponWeight(item.name) <= MaxWeight then
					table.insert(trunkData.weapons, {
						name = item.name,
						label = item.label,
						ammo = item.ammo,
						count = 1
					})
	
					xPlayer['loadout'].removeWeapon(item.name)
					xPlayer.showNotification("Vous avez déposer ~g~"..item.label.."~s~ !")
					message = ("(Coffre Véhicule) **%s** à déposer **%s**, plaque **%s**"):format(GetPlayerName(src), item.label, plate)
					can, found = true, true;
				end
			else
				can, found = 'maxWeight', true;
			end
		end

		if can and can ~= 'maxWeight' then
			MySQL.query("INSERT INTO trunk_inventory (`plate`, `data`, `owned`) VALUES (?, ?, ?)", {plate, json.encode(trunkData), owned})
			exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
		end
	end

	Wait(500)

	if not found then
		if type == 'item_accounts' then
			if (coffreWeight + (Framework.Math.Round(qte/100000, 1))) <= MaxWeight then
				if tonumber(xPlayer['accounts'].getAccount(item.name).money) >= tonumber(qte) then
					trunkData.accounts[item.name] = qte
	
					xPlayer['accounts'].removeAccountMoney(item.name, qte)
					xPlayer.showNotification("Vous avez déposer ~g~"..qte.."$~s~ !")
					message = ("(Coffre Véhicule NOT FOUND) **%s** à déposer **%s**$ **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
					can = true;
				end
			else
				can = 'maxWeight';
			end
	    elseif type == 'item_standard' then
			if coffreWeight + VehicleTrunk.GetItemWeight(item.name)*qte <= MaxWeight then
				if tonumber(xPlayer['inventory'].getInventoryItem(item.name).count) >= tonumber(qte) then
					table.insert(trunkData.items, {
						name = item.name,
						label = item.label,
						count = qte
					})
	
					xPlayer['inventory'].removeInventoryItem(item.name, qte)
					xPlayer.showNotification("Vous avez déposer ~b~"..qte.."x ~g~"..item.label.."~s~ !")
					message = ("(Coffre Véhicule NOT FOUND) **%s** à déposer **%s**x **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
					can = true;
				end
			else
				can = 'maxWeight';
			end
		elseif type == 'item_weapon' then
			if xPlayer['loadout'].hasWeapon(item.name) then
				if coffreWeight + VehicleTrunk.GetWeaponWeight(item.name) <= MaxWeight then
					table.insert(trunkData.weapons, {
						name = item.name,
						label = item.label,
						ammo = item.ammo,
						count = 1
					})
	
					xPlayer['loadout'].removeWeapon(item.name)
					xPlayer.showNotification("Vous avez déposer ~g~"..item.label.."~s~ !")
					message = ("(Coffre Véhicule NOT FOUND) **%s** à déposer **%s**, plaque **%s**"):format(GetPlayerName(src), item.label, plate)
					can = true;
				end
			else
				can = 'maxWeight';
			end
		end

		if can and can ~= 'maxWeight' then
			MySQL.query("UPDATE trunk_inventory SET data = ? WHERE plate = ?", {json.encode(trunkData), plate})
			exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
		end
	end

	if not can then
		xPlayer.showNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
	elseif can == 'maxWeight' then
		xPlayer.showNotification("~r~Il n'y a pas asser de place dans le coffre !~s~")
	end
end)

VehicleTrunk.inRemoving = {}

RegisterNetEvent('vehicletrunk:remove')
AddEventHandler('vehicletrunk:remove', function(type, plate, item, qte)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	local data = {}

	if not VehicleTrunk.inRemoving[plate] then
		VehicleTrunk.inRemoving[plate] = true;
	    time = math.random(1, 1500)
		Wait(time)
		MySQL.query('SELECT * FROM `trunk_inventory` WHERE `plate` = ?', {plate}, function(result)
			if result then
				for i = 1, #result do
					data = json.decode(result[i].data)
				end
				if data ~= nil then
					if type == 'item_accounts' then
						if item.count >= tonumber(qte) then
							if data.accounts[item.name] then
								if tonumber(data.accounts[item.name]) >= tonumber(qte) then
									local finalCount = tonumber(data.accounts[item.name] - qte)
									if finalCount > 0 then
										data.accounts[item.name] = finalCount;
									else
										data.accounts[item.name] = 0;
									end
									print("save")
									MySQL.update.await("UPDATE trunk_inventory SET data = ? WHERE plate = ?", {json.encode(data), plate})
									print("saved")
									xPlayer['accounts'].addAccountMoney(item.name, qte)
									xPlayer.showNotification("Vous avez retiré ~g~"..qte.."$~s~ !")
									message = ("(Coffre Véhicule) **%s** à retirer **%s**$, plaque **%s**"):format(GetPlayerName(src), qte, plate)
									exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
									VehicleTrunk.inRemoving[plate] = false;
								else
									xPlayer.showNotification("~r~Action Impossible !~s~")
								end
							else
								xPlayer.showNotification("~r~Action Impossible !~s~")
							end
						else
							xPlayer.showNotification("~r~Action Impossible !~s~")
						end
					elseif type == 'item_standard' then
						if xPlayer['inventory'].canCarryItem(item.name, qte) then
							for k,v in pairs(data.items) do
								if v.name == item.name and tonumber(data.items[k].count) >= tonumber(qte) then
									if tonumber(v.count) >= tonumber(qte) then
										local finalCount = tonumber(data.items[k].count - qte)
										if finalCount > 0 then
											data.items[k].count = finalCount;
										else
											table.remove(data.items, k)
										end
										MySQL.query("UPDATE trunk_inventory SET data = ? WHERE plate = ?", {json.encode(data), plate})
										xPlayer['inventory'].addInventoryItem(item.name, qte)
										xPlayer.showNotification("Vous avez retiré ~b~"..qte.."x ~g~"..item.label.."~s~ !")
										message = ("(Coffre Véhicule) **%s** à retirer **%s**x **%s**, plaque **%s**"):format(GetPlayerName(src), qte, item.label, plate)
										exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
										VehicleTrunk.inRemoving[plate] = false;
									end
								end
							end
						else
							xPlayer.showNotification("~r~Action Impossible (pas assez de place sur vous) !~s~")
						end
					elseif type == 'item_weapon' then
						for k,v in pairs(data.weapons) do
							if v.name == item.name and tonumber(data.weapons[k].count) > 0 then
								if not xPlayer['loadout'].hasWeapon(item.name) then
									local finalCount = tonumber(data.weapons[k].count - 1)
									if finalCount > 0 then
										data.weapons[k].count = finalCount;
									else
										table.remove(data.weapons, k)
									end
									MySQL.query("UPDATE trunk_inventory SET data = ? WHERE plate = ?", {json.encode(data), plate})
									xPlayer['loadout'].addWeapon(item.name, v.ammo)
									xPlayer.showNotification("Vous avez retiré ~g~"..item.label.."~s~ !")
									message = ("(Coffre Véhicule) **%s** à retirer **%s**, plaque **%s**"):format(GetPlayerName(src), item.label, plate)
									exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
									VehicleTrunk.inRemoving[plate] = false;
								else
									xPlayer.showNotification("~r~Vous avez déjà cette arme sur vous !")
									VehicleTrunk.inRemoving[plate] = false;
								end
							end
						end
					end
				end
			end
		end)
	else
		xPlayer.showNotification("~r~Vous ne pouvez pas effectué cette action en même temps qu'une autre personne !~s~")
	end

	Wait(15000)
	VehicleTrunk.inRemoving[plate] = false;
end)