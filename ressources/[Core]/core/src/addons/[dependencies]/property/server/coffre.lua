
Framework.RegisterServerCallback('property:getCoffre', function(src, cb, propertyId)
    cb(SharedProperty[propertyId].data["coffre"])
end)

Framework.RegisterServerCallback("property:getCoffreMoney", function(src, cb, propertyId)
    cb(SharedProperty[propertyId].data["coffre"]['accounts']['money'])
end)

Framework.RegisterServerCallback("property:getCoffreMoney2", function(src, cb, propertyId)
    cb(SharedProperty[propertyId].data["coffre"]['accounts']['black_money'])
end)

Framework.RegisterServerCallback("property:getCoffreMoneyAll", function(src, cb, propertyId)
    cb(SharedProperty[propertyId].data["coffre"]['accounts']['money'], SharedProperty[propertyId].data["coffre"]['accounts']['black_money'])
end)

RegisterServerEvent('property:depositMoney')
AddEventHandler('property:depositMoney', function(propertyId, amount)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = xPlayer['accounts'].getAccount('money').money

    if tonumber(myMoney) >= amount then
        xPlayer['accounts'].removeAccountMoney('money', amount)
        SharedProperty[propertyId].data["coffre"]["accounts"]['money'] = SharedProperty[propertyId].data["coffre"]["accounts"]['money'] + amount
        exports['Logs']:createLog({EmbedMessage = ("(Coffre Propriété) **%s** à déposer **%s**$, propriété ID **%s**"):format(GetPlayerName(source), amount, propertyId), player_id = source, channel = 'interactions'})
    else
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('property:depositMoney2')
AddEventHandler('property:depositMoney2', function(propertyId, amount)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = xPlayer['accounts'].getAccount('black_money').money

    if tonumber(myMoney) >= amount then
        xPlayer['accounts'].removeAccountMoney('black_money', amount)
        SharedProperty[propertyId].data["coffre"]["accounts"]['black_money'] = SharedProperty[propertyId].data["coffre"]["accounts"]['black_money'] + amount
        exports['Logs']:createLog({EmbedMessage = ("(Coffre Propriété) **%s** à déposer **%s**$ SALE, propriété ID **%s**"):format(GetPlayerName(source), amount, propertyId), player_id = source, channel = 'interactions'})
    else
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('property:removeMoney')
AddEventHandler('property:removeMoney', function(propertyId, amount)
    local xPlayer = Framework.GetPlayerFromId(source)

    time = math.random(1, 1500)
    Wait(time)
    if SharedProperty[propertyId].data["coffre"]["accounts"]['money'] >= amount then
        SharedProperty[propertyId].data["coffre"]["accounts"]['money'] = SharedProperty[propertyId].data["coffre"]["accounts"]['money'] - amount
        xPlayer['accounts'].addAccountMoney('money', amount)
        exports['Logs']:createLog({EmbedMessage = ("(Coffre Propriété) **%s** à retirer **%s**$, propriété ID **%s**"):format(GetPlayerName(source), amount, propertyId), player_id = source, channel = 'interactions'})
    else 
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('property:removeMoney2')
AddEventHandler('property:removeMoney2', function(propertyId, amount)
    local xPlayer = Framework.GetPlayerFromId(source)

    time = math.random(1, 1500)
    Wait(time)
    if SharedProperty[propertyId].data["coffre"]["accounts"]['black_money'] >= amount then
        SharedProperty[propertyId].data["coffre"]["accounts"]['black_money'] = SharedProperty[propertyId].data["coffre"]["accounts"]['black_money'] - amount
        xPlayer['accounts'].addAccountMoney('black_money', amount)
        exports['Logs']:createLog({EmbedMessage = ("(Coffre Propriété) **%s** à retirer **%s**$ SALE, propriété ID **%s**"):format(GetPlayerName(source), amount, propertyId), player_id = source, channel = 'interactions'})
    else 
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('property:depositCoffre')
AddEventHandler('property:depositCoffre', function(propertyId, type, item, qte)
    local message = nil;
    local xPlayer = Framework.GetPlayerFromId(source)

    if type == 'item_standard' then
        local pItem = xPlayer['inventory'].getInventoryItem(item.name)
        if tonumber(pItem.count) >= qte then
            if SharedProperty[propertyId].data["coffre"]["items"] then 
                if not SharedProperty[propertyId].data["coffre"]["items"][item.name] then 
                    SharedProperty[propertyId].data["coffre"]["items"][item.name] = {}
                    SharedProperty[propertyId].data["coffre"]["items"][item.name].name = item.name 
                    SharedProperty[propertyId].data["coffre"]["items"][item.name].label = item.label
                    SharedProperty[propertyId].data["coffre"]["items"][item.name].count = qte
                else 
                    SharedProperty[propertyId].data["coffre"]["items"][item.name].count = SharedProperty[propertyId].data["coffre"]["items"][item.name].count + qte
                end

                xPlayer['inventory'].removeInventoryItem(item.name, qte)
                message = ("(Coffre Propriété) **%s** à déposer **%s**x **%s**, propriété ID **%s** "):format(GetPlayerName(source), qte, item.label, propertyId)
            else
                xPlayer.showNotification("~r~L'objet n'existe plus !")
            end
        else
            xPlayer.showNotification("~r~Montant Invalide !")
        end
    elseif type == 'item_weapon' then
        if xPlayer['loadout'].hasWeapon(item.name) then
            if not SharedProperty[propertyId].data["coffre"]["weapons"][item.name] then 
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name] = {}
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].name = item.name 
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].label = item.label
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].ammo = item.ammo
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].components = item.components
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].tintIndex = item.tintIndex
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count = 1
            else 
                SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count = SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count + 1
            end

            xPlayer['loadout'].removeWeapon(item.name)
            message = ("(Coffre Propriété) **%s** à déposer **%s**, propriété ID **%s** "):format(GetPlayerName(source), item.label, propertyId)
        else
            xPlayer.showNotification("~r~Vous n'avez pas cette Arme !")
        end
    end

    if message ~= nil then
        exports['Logs']:createLog({EmbedMessage = (message), player_id = source, channel = 'interactions'})
    end
end)

RegisterServerEvent('property:removeCoffre')
AddEventHandler('property:removeCoffre', function(propertyId, type, item, qte)
    local message = nil;
    local xPlayer = Framework.GetPlayerFromId(source)

    time = math.random(1, 1500)
    Wait(time)
    if type == 'item_standard' then
        if xPlayer['inventory'].canCarryItem(item.name, qte) then
            if SharedProperty[propertyId].data["coffre"]["items"] and SharedProperty[propertyId].data["coffre"]["items"][item.name] and tonumber(SharedProperty[propertyId].data["coffre"]["items"][item.name].count) >= tonumber(qte) then
                if tonumber(SharedProperty[propertyId].data["coffre"]["items"][item.name].count) >= qte then 
                    if (tonumber(SharedProperty[propertyId].data["coffre"]["items"][item.name].count) - qte) > 0 then 
                        SharedProperty[propertyId].data["coffre"]["items"][item.name].count = SharedProperty[propertyId].data["coffre"]["items"][item.name].count - qte
                    else 
                        SharedProperty[propertyId].data["coffre"]["items"][item.name] = nil
                    end

                    xPlayer['inventory'].addInventoryItem(item.name, qte)
                    message = ("(Coffre Propriété) **%s** à retirer **%s**x **%s**, propriété ID **%s** "):format(GetPlayerName(source), qte, item.label, propertyId)
                else
                    xPlayer.showNotification("~r~Il n'y a pas asser d'objets dans le coffre !")
                end
            else
                xPlayer.showNotification("~r~Cette objet n'est plus dans le coffre !")
            end
        else
            xPlayer.showNotification("~r~Vous n'avez pas asser de place sur vous !")
        end
    elseif type == 'item_weapon' then
        if not xPlayer['loadout'].hasWeapon(item.name) then
            if SharedProperty[propertyId].data["coffre"]["weapons"] and SharedProperty[propertyId].data["coffre"]["weapons"][item.name] then 
                if tonumber(SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count) >= 1 then 
                    if (tonumber(SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count) - 1) > 0 then 
                        SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count = SharedProperty[propertyId].data["coffre"]["weapons"][item.name].count - 1
                    else 
                        SharedProperty[propertyId].data["coffre"]["weapons"][item.name] = nil
                    end

                    xPlayer['loadout'].addWeapon(item.name, item.ammo)
                    message = ("(Coffre Propriété) **%s** à retirer **%s**, propriété ID **%s** "):format(GetPlayerName(source), item.label, propertyId)
                else
                    xPlayer.showNotification("~r~Il n'y a pas asser d'arme dans le coffre !")
                end
            else
                xPlayer.showNotification("~r~Cette arme n'est plus dans le coffre !")
            end
        else
            xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
        end
    end

    if message ~= nil then
        exports['Logs']:createLog({EmbedMessage = (message), player_id = source, channel = 'interactions'})
    end
end)