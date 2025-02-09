Coffres = {}

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source, character)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
	local chests = {}

	MySQL.Async.fetchAll('SELECT * FROM chests', {}, function(data)
        for k,v in pairs(data) do
			table.insert(chests, {
				id = v.id,
				characterId = v.characterId,
				coords = json.decode(v.coords),
				code = v.code
			})
        end
		Wait(500)
		xPlayer.triggerEvent('coffres:loadChests', chests)
	end)
end)

Framework.ITEMS:RegisterUsableItem('chest', function(source)
	TriggerClientEvent('coffres:spawnChest', source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('chest', 1)
end)

RegisterServerEvent('coffres:addNewChest')
AddEventHandler('coffres:addNewChest', function(coords, heading, code)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	local coordsChest = {x = coords.x, y = coords.y, z = coords.z, h = heading};
	local data = {accounts = {}, inventory = {}, loadout = {}};

	local id = MySQL.insert.await('INSERT INTO chests (characterId, coords, code, data) VALUES (?, ?, ?, ?)', {
		xPlayer.characterId, json.encode(coordsChest), code, json.encode(data)
	})

	local chest = {
		id = id,
		characterId = xPlayer.characterId,
		coords = coordsChest,
		code = code
	}
	xPlayer.triggerEvent('coffres:addNewChest', chest)
	xPlayer.showNotification("Vous avez placé un nouveau coffre fort !")
end)

RegisterServerEvent('coffres:removeChest')
AddEventHandler('coffres:removeChest', function(chestId)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	if xPlayer.group ~= 'user' then
		MySQL.query.await('DELETE FROM chests WHERE id = ?', {chestId})
		TriggerClientEvent('coffres:removeChest', -1, chestId)
		xPlayer.showNotification("Vous avez supprimé un coffre fort !")
	else
		xPlayer.showNotification("~r~Vous ne pouvez pas effectuer cela !~s~")
	end
end)

RegisterServerEvent('coffres:checkCode')
AddEventHandler('coffres:checkCode', function(id, code)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

	MySQL.Async.fetchAll('SELECT * FROM chests WHERE id = ?', {id}, function(data)
		if data ~= nil then
			for k,v in pairs(data) do
				if tostring(v.code) == tostring(code) then
					TriggerClientEvent('coffres:notifCode', src, true, id, json.decode(v.data))
				else
					TriggerClientEvent('coffres:notifCode', src, false, id, nil)
				end
			end
		else
			print("^1 Coffre ID "..id.." invalide !^0")
		end
	end)
end)

RegisterServerEvent('coffres:deposit')
AddEventHandler('coffres:deposit', function(type, item, qte, coffreId)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)

	local can = false;
	local message = "(Coffre placeable) Invalide";

	MySQL.Async.fetchAll("SELECT * FROM chests WHERE id = ?", {coffreId}, function(result)
		if result ~= nil then
			for k,v in pairs(result) do data = json.decode(v.data) end

			if type == 'item_account' then

		    elseif type == 'item_standard' then
				if not next(data.inventory) then
					table.insert(data.inventory, {
						name = item.name,
						label = item.label,
						count = qte  
					})
					xPlayer['inventory'].removeInventoryItem(item.name, qte)
					xPlayer.showNotification("Vous avez déposer ~b~"..qte.."x ~g~"..item.label.."~s~ !")
					can = true;
				elseif next(data.inventory) then
					local found = false;
					for k,v in pairs(data.inventory) do
						if v.name == item.name then
							found = true;
							local TotalCount = tonumber(qte + v.count)
							v.name  = item.name;
							v.label = item.label;
							v.count  = TotalCount;

							xPlayer['inventory'].removeInventoryItem(item.name, qte)
							xPlayer.showNotification("Vous avez déposer ~b~"..qte.."x ~g~"..item.label.."~s~ !")
						end
					end
					if not found then
						table.insert(data.inventory, {
							name = item.name,
							label = item.label,
							count = qte  
						})

						xPlayer['inventory'].removeInventoryItem(item.name, qte)
						xPlayer.showNotification("Vous avez déposer ~b~"..qte.."x ~g~"..item.label.."~s~ !")
					end
					can = true;
				end
			elseif type == 'item_weapon' then

			end
			Wait(750)
			if can and can ~= 'maxWeight' then
				MySQL.query("UPDATE chests SET data = ? WHERE id = ?", {json.encode(data), coffreId})
				-- exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
			end
		end
	end)
end)

Coffres.inRemoving = {}

RegisterServerEvent('coffres:remove')
AddEventHandler('coffres:remove', function(type, item, qte, coffreId)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)

	local can = false;
	local message = "(Coffre placeable) Invalide";

	time = math.random(1, 1500)
    Wait(time)
	if not Coffres.inRemoving[coffreId] then
		Coffres.inRemoving[coffreId] = true;
		MySQL.Async.fetchAll("SELECT * FROM chests WHERE id = ?", {coffreId}, function(result)
			if result ~= nil then
				for k,v in pairs(result) do data = json.decode(v.data) end
	
				if type == 'item_account' then
	
				elseif type == 'item_standard' then
					if not next(data.inventory) then end
					if xPlayer['inventory'].canCarryItem(item.name, qte) then
						for k,v in pairs(data.inventory) do
							if v.name == item.name then
								if v.count >= qte then
									local TotalCount = tonumber(v.count - qte)
									v.name  = item.name;
									v.label = item.label;
									v.count  = TotalCount;
									if TotalCount < 1 then table.remove(data.inventory, k) end
		
									xPlayer['inventory'].addInventoryItem(item.name, qte)
									xPlayer.showNotification("Vous avez retiré ~b~"..qte.."x ~g~"..item.label.."~s~ !")
									can = true;
								else
									xPlayer.showNotification("~r~Quantité Invalide !~s~")
								end
							end
						end
					else
						xPlayer.showNotification("~r~Vous ne pouvez pas porter cela !~s~")
					end
				elseif type == 'item_weapon' then
	
				end
				Wait(750)
				if can and can ~= 'maxWeight' then
					Coffres.inRemoving[coffreId] = false;
					MySQL.query("UPDATE chests SET data = ? WHERE id = ?", {json.encode(data), coffreId})
					-- exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'interactions'})
				end
			end

			if not can then
				Coffres.inRemoving[coffreId] = false;
				xPlayer.showNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
			end
		end)
	else
		xPlayer.showNotification("~r~Vous ne pouvez pas effectué cette action en même temps qu'une autre personne !~s~")
	end
end)	
