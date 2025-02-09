

RegisterNetEvent("SheriffJob:Menotter")
AddEventHandler("SheriffJob:Menotter", function(player)
    TriggerClientEvent("SheriffJob:Menotter", player)
end)

RegisterNetEvent("SheriffJob:Escorter")
AddEventHandler("SheriffJob:Escorter", function(player)
    TriggerClientEvent("SheriffJob:Escorter", player, source)
end)

RegisterNetEvent("SheriffJob:MettreSortirVeh")
AddEventHandler("SheriffJob:MettreSortirVeh", function(player)
    TriggerClientEvent("SheriffJob:MettreSortirVeh", player)
end)

Framework.RegisterServerCallback("SheriffJob:getPlayerData", function(source, cb, player)
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

RegisterNetEvent("SheriffJob:Confiscate")
AddEventHandler("SheriffJob:Confiscate", function(player, type, item, quantite)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(player)

    if type == 'item' then
        if xPlayer['inventory'].canCarryItem(item.name, quantite) then
            if tPlayer['inventory'].getInventoryItem(item.name).count >= quantite then
                tPlayer['inventory'].removeInventoryItem(item.name, quantite)
                xPlayer['inventory'].addInventoryItem(item.name, quantite)
    
                exports['Logs']:createLog({EmbedMessage = ("[Sheriff] **%s** à Confisquer **%s**x **%s** à **%s**"):format(GetPlayerName(source), quantite, Framework.ITEMS:GetItemLabel(item.name), GetPlayerName(player)), player_id = source, player_2_id = player, channel = 'interactions'})
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
                
                exports['Logs']:createLog({EmbedMessage = ("[Sheriff] **%s** à Confisquer **%s** à **%s**"):format(GetPlayerName(source), Framework.GetWeaponLabel(item.name), GetPlayerName(player)), player_id = source, player_2_id = player, channel = 'interactions'})
            else
                xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
            end
        else
            xPlayer.showNotification("~r~Le joueur n'a plus cette Arme !")
        end
    end
end)

Framework.RegisterServerCallback("SheriffJob:getVehicleInfos", function(source, cb, plate)
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
RegisterNetEvent("SheriffJob:Renfort")
AddEventHandler("SheriffJob:Renfort", function(type, coords)
    local _source = Framework.GetPlayerFromId(source)
    if(canUseRenfort) then
        canUseRenfort = false
        local xPlayers = Framework.GetExtendedPlayers()

        for _, xPlayer in pairs(xPlayers) do
            if xPlayer['jobs'] ~= nil then
                if xPlayer['jobs'].getJob().name == 'sheriff' then
                    xPlayer.triggerEvent("SheriffJob:setBlip", coords, type)
                end
            end
        end
        Citizen.Wait(8000)
        canUseRenfort = true
    else
        _source.showNotification("Une demande de renfort a déjà été faite récemment")
    end
end)