

RegisterNetEvent("SwatJob:Menotter")
AddEventHandler("SwatJob:Menotter", function(player)
    TriggerClientEvent("SwatJob:Menotter", player)
end)

RegisterNetEvent("SwatJob:Escorter")
AddEventHandler("SwatJob:Escorter", function(player)
    TriggerClientEvent("SwatJob:Escorter", player, source)
end)

RegisterNetEvent("SwatJob:MettreSortirVeh")
AddEventHandler("SwatJob:MettreSortirVeh", function(player)
    TriggerClientEvent("SwatJob:MettreSortirVeh", player)
end)

Framework.RegisterServerCallback("SwatJob:getPlayerData", function(source, cb, player)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(player)
    local playerData = {
        src = player,
        inventory = {},
        loadout = {}
    }

    for k,v in pairs(tPlayer['inventory'].inventory) do
        if v.count > 0 then
            table.insert(playerData.inventory, {
                itemName = v.name,
                itemLabel = v.label,
                itemCount = v.count
            })
        end
    end

    for k,v in pairs(tPlayer['loadout'].loadout) do
        table.insert(playerData.loadout, {
            weaponName = v.name,
            weaponLabel = v.label,
            weaponAmmo = v.ammo
        })
    end

    cb(playerData)
end)

RegisterNetEvent("SwatJob:Confiscate")
AddEventHandler("SwatJob:Confiscate", function(player, type, item, quantite)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(player)

    if type == 'item' then
        if xPlayer['inventory'].canCarryItem(item.name, quantite) then
            if tPlayer['inventory'].getInventoryItem(item.name).count >= quantite then
                tPlayer['inventory'].removeInventoryItem(item.name, quantite)
                xPlayer['inventory'].addInventoryItem(item.name, quantite)
    
                exports['Logs']:createLog({EmbedMessage = ("[SWAT] **%s** à Confisquer **%s**x **%s** à **%s**"):format(GetPlayerName(source), quantite, Framework.ITEMS:GetItemLabel(item.name), GetPlayerName(player)), player_id = source, player_2_id = player, channel = 'interactions'})
            else
                xPlayer.showNotification("~r~Le joueur n'a pas assez d'items !")
            end
        else
            xPlayer.showNotification("~r~Vous n'avez pas assez de place sur vous !")
        end
    else
        if tPlayer['loadout'].hasWeapon(item.name) then
            if not xPlayer['loadout'].hasWeapon(item.name) then
                tPlayer['loadout'].removeWeapon(item.name)
                xPlayer['loadout'].addWeapon(item.name, item.ammo)
                
                exports['Logs']:createLog({EmbedMessage = ("[SWAT] **%s** à Confisquer **%s** à **%s**"):format(GetPlayerName(source), Framework.GetWeaponLabel(item.name), GetPlayerName(player)), player_id = source, player_2_id = player, channel = 'interactions'})
            else
                xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
            end
        else
            xPlayer.showNotification("~r~Le joueur n'a plus cette Arme !")
        end
    end
end)

Framework.RegisterServerCallback("SwatJob:getVehicleInfos", function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT identity FROM characters WHERE characterId = @characterId',  {
				['@characterId'] = result[1].characterId
			}, function(result2)
                local identity = json.decode(result2[1].identity)
				retrivedInfo.owner = identity.firstname .. ' ' .. identity.lastname
                retrivedInfo.plate = plate

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

local canUseRenfort = true
RegisterNetEvent("SwatJob:Renfort")
AddEventHandler("SwatJob:Renfort", function(type, coords)
    local _source = Framework.GetPlayerFromId(source)
    if(canUseRenfort) then
        canUseRenfort = false
        local xPlayers = Framework.GetExtendedPlayers()

        for _, xPlayer in pairs(xPlayers) do
            if xPlayer['jobs'] ~= nil then
                if xPlayer['jobs'].getJob().name == 'swat' then
                    xPlayer.triggerEvent("SwatJob:setBlip", coords, type)
                end
            end
        end
        Citizen.Wait(8000)
        canUseRenfort = true
    else
        _source.showNotification("Une demande de renfort a déjà été faite récemment")
    end
end)