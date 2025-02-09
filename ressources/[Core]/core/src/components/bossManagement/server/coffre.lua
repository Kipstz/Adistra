
Framework.RegisterServerCallback('bossManagement:getCoffre', function(src, cb, societeName)
    cb(SharedSocietes[societeName].data)
end)

RegisterServerEvent('bossManagement:deposit')
AddEventHandler('bossManagement:deposit', function(societeName, type, item, qte)
    local message = nil;
    local xPlayer = Framework.GetPlayerFromId(source)

    if type == 'item_standard' then
        local pItem = xPlayer['inventory'].getInventoryItem(item.name)
        if tonumber(pItem.count) >= qte then
            if SharedSocietes[societeName].data["items"] then 
                if not SharedSocietes[societeName].data["items"][item.name] then 
                    SharedSocietes[societeName].data["items"][item.name] = {}
                    SharedSocietes[societeName].data["items"][item.name].name = item.name 
                    SharedSocietes[societeName].data["items"][item.name].label = item.label
                    SharedSocietes[societeName].data["items"][item.name].count = qte
                else 
                    SharedSocietes[societeName].data["items"][item.name].count = SharedSocietes[societeName].data["items"][item.name].count + qte
                end

                xPlayer['inventory'].removeInventoryItem(item.name, qte)
                message = ("(Coffre Société) **%s** à déposer **%s**x **%s**, société **%s**"):format(GetPlayerName(source), qte, item.label, societeName)
            else
                xPlayer.showNotification("~r~L'objet n'existe plus !")
            end
        else
            xPlayer.showNotification("~r~Montant Invalide !")
        end
    elseif type == 'item_weapon' then
        if xPlayer['loadout'].hasWeapon(item.name) then
            if not SharedSocietes[societeName].data["weapons"][item.name] then 
                SharedSocietes[societeName].data["weapons"][item.name] = {}
                SharedSocietes[societeName].data["weapons"][item.name].name = item.name 
                SharedSocietes[societeName].data["weapons"][item.name].label = item.label
                SharedSocietes[societeName].data["weapons"][item.name].ammo = item.ammo
                SharedSocietes[societeName].data["weapons"][item.name].components = item.components
                SharedSocietes[societeName].data["weapons"][item.name].tintIndex = item.tintIndex
                SharedSocietes[societeName].data["weapons"][item.name].count = 1
            else 
                SharedSocietes[societeName].data["weapons"][item.name].count = SharedSocietes[societeName].data["weapons"][item.name].count + 1
            end

            xPlayer['loadout'].removeWeapon(item.name)
            message = ("(Coffre Société) **%s** à déposer **%s**, société **%s**"):format(GetPlayerName(source), item.label, societeName)
        else
            xPlayer.showNotification("~r~Vous n'avez pas cette Arme !")
        end
    end

    if message ~= nil then
        exports['Logs']:createLog({EmbedMessage = (message), player_id = source, channel = 'interactions'})
    end
end)

bossManagement.inRemoving = {}

RegisterServerEvent('bossManagement:remove')
AddEventHandler('bossManagement:remove', function(societeName, type, item, qte)
    local message = nil;
    local xPlayer = Framework.GetPlayerFromId(source)

    if(xPlayer['jobs'].getJob().name ~= societeName) then
        exports['ac']:fg_BanPlayer(source, 'Tentative bossManagement:remove ('..societeName..') (Noob)', true)
        return
    end

    if not bossManagement.inRemoving[societeName] then
		bossManagement.inRemoving[societeName] = true;
        if type == 'item_standard' then
            if xPlayer['inventory'].canCarryItem(item.name, qte) then
                if SharedSocietes[societeName].data["items"] and SharedSocietes[societeName].data["items"][item.name] then
                    if tonumber(SharedSocietes[societeName].data["items"][item.name].count) >= qte then 
                        if (tonumber(SharedSocietes[societeName].data["items"][item.name].count) - qte) > 0 then 
                            SharedSocietes[societeName].data["items"][item.name].count = SharedSocietes[societeName].data["items"][item.name].count - qte
                        else 
                            SharedSocietes[societeName].data["items"][item.name] = nil
                        end
    
                        xPlayer['inventory'].addInventoryItem(item.name, qte)
                        bossManagement.inRemoving[societeName] = false;
                        message = ("(Coffre Société) **%s** à retirer **%s**x **%s**, société **%s**"):format(GetPlayerName(source), qte, item.label, societeName)
                    else
                        bossManagement.inRemoving[societeName] = false;
                        xPlayer.showNotification("~r~Il n'y a pas asser d'objets dans le coffre !")
                    end
                else
                    bossManagement.inRemoving[societeName] = false;
                    xPlayer.showNotification("~r~Cette objet n'est plus dans le coffre !")
                end
            else
                bossManagement.inRemoving[societeName] = false;
                xPlayer.showNotification("~r~Vous n'avez pas asser de place sur vous !")
            end
        elseif type == 'item_weapon' then
            if not xPlayer['loadout'].hasWeapon(item.name) then
                if SharedSocietes[societeName].data["weapons"] and SharedSocietes[societeName].data["weapons"][item.name] then 
                    if tonumber(SharedSocietes[societeName].data["weapons"][item.name].count) >= 1 then 
                        if (tonumber(SharedSocietes[societeName].data["weapons"][item.name].count) - 1) > 0 then 
                            SharedSocietes[societeName].data["weapons"][item.name].count = SharedSocietes[societeName].data["weapons"][item.name].count - 1
                        else 
                            SharedSocietes[societeName].data["weapons"][item.name] = nil
                        end
    
                        xPlayer['loadout'].addWeapon(item.name, item.ammo)
                        bossManagement.inRemoving[societeName] = false;
                        message = ("(Coffre Société) **%s** à retirer **%s**, société **%s**"):format(GetPlayerName(source), item.label, societeName)
                    else
                        bossManagement.inRemoving[societeName] = false;
                        xPlayer.showNotification("~r~Il n'y a pas asser d'arme dans le coffre !")
                    end
                else
                    bossManagement.inRemoving[societeName] = false;
                    xPlayer.showNotification("~r~Cette arme n'est plus dans le coffre !")
                end
            else
                bossManagement.inRemoving[societeName] = false;
                xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
            end
        end
    else
		xPlayer.showNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
    end

    if message ~= nil then
        exports['Logs']:createLog({EmbedMessage = (message), player_id = source, channel = 'interactions'})
    end
end)