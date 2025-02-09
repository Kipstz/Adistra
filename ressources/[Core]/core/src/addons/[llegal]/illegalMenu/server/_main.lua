RegisterNetEvent('IllegalMenu:Ligoter')
AddEventHandler('IllegalMenu:Ligoter', function(player)
    TriggerClientEvent('IllegalMenu:Ligoter', player)
end)

RegisterNetEvent('IllegalMenu:Escorter')
AddEventHandler('IllegalMenu:Escorter', function(player)
    TriggerClientEvent('IllegalMenu:Escorter', player, source)
end)

RegisterNetEvent('IllegalMenu:MettreSortirVeh')
AddEventHandler('IllegalMenu:MettreSortirVeh', function(player)
    TriggerClientEvent('IllegalMenu:MettreSortirVeh', player)
end)

Framework.RegisterServerCallback("IllegalMenu:getPlayerData", function(source, cb, player)
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

RegisterNetEvent('IllegalMenu:Confiscate')
AddEventHandler('IllegalMenu:Confiscate', function(player, type, item, quantite)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(player)

    if type == 'item' then
        if xPlayer['inventory'].canCarryItem(item.name, quantite) then
            if tPlayer['inventory'].getInventoryItem(item.name).count >= quantite then
                tPlayer['inventory'].removeInventoryItem(item.name, quantite)
                xPlayer['inventory'].addInventoryItem(item.name, quantite)
    
                exports['Logs']:createLog({EmbedMessage = ("[ILLEGAL MENU] **%s** à Confisquer **%s**x **%s** à **%s**"):format(GetPlayerName(source), quantite, Framework.ITEMS:GetItemLabel(item.name), GetPlayerName(player)), player_id = source, player_2_id = player, channel = 'interactions'})
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
                
                exports['Logs']:createLog({EmbedMessage = ("[ILLEGAL MENU] **%s** à Confisquer **%s** à **%s**"):format(GetPlayerName(source), Framework.GetWeaponLabel(item.name), GetPlayerName(player)), player_id = source, player_2_id = player, channel = 'interactions'})
            else
                xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
            end
        else
            xPlayer.showNotification("~r~Le joueur n'a plus cette Arme !")
        end
    end
end)