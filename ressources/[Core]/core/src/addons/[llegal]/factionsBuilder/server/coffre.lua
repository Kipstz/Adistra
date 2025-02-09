
local function SizeOfTable(t)
    local count = 0

    for k,v in pairs(t) do
        count = count + 1
    end

    return count
end

local function GetCoffreWeight(faction)
    if SharedFactions[faction] then 
        local countList = {}
        if json.encode(SharedFactions[faction].data["items"]) == "[]" then 
            return 0
        else 
            for k,v in pairs(SharedFactions[faction].data["items"]) do 
                table.insert(countList, v.count)
            end
            return SizeOfTable(countList)
        end
    else 
        return nil
    end
end

Framework.RegisterServerCallback('factions:getCoffre', function(src, cb, faction)
    cb(SharedFactions[faction].data)
end)

RegisterServerEvent('factions:depositMoney')
AddEventHandler('factions:depositMoney', function(faction, amount)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = xPlayer['accounts'].getAccount('black_money').money

    if tonumber(myMoney) >= amount then
        xPlayer['accounts'].removeAccountMoney('black_money', amount)
        SharedFactions[faction].data["accounts"]['black_money'] = SharedFactions[faction].data["accounts"]['black_money'] + amount
        exports['Logs']:createLog({EmbedMessage = ("(Coffre Faction) **%s** à déposer **%s**$, faction: **%s**"):format(GetPlayerName(source), amount, faction), player_id = source, channel = 'interactions'})
    else
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('factions:removeMoney')
AddEventHandler('factions:removeMoney', function(faction, amount)
    local xPlayer = Framework.GetPlayerFromId(source)

    if SharedFactions[faction].data["accounts"]['black_money'] >= amount then
        SharedFactions[faction].data["accounts"]['black_money'] = SharedFactions[faction].data["accounts"]['black_money'] - amount
        xPlayer['accounts'].addAccountMoney('black_money', amount)
        exports['Logs']:createLog({EmbedMessage = ("(Coffre Faction) **%s** à retirer **%s**$, faction: **%s**"):format(GetPlayerName(source), amount, faction), player_id = source, channel = 'interactions'})
    else 
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('factions:deposit')
AddEventHandler('factions:deposit', function(faction, type, item, qte)
    local message = nil;
    local xPlayer = Framework.GetPlayerFromId(source)
    item.name = tostring(item.name)

    if type == 'item_standard' then
        local pItem = xPlayer['inventory'].getInventoryItem(item.name).count
        print(qte)
        if tonumber(pItem) >= tonumber(qte) then
            if SharedFactions[faction].data["items"] then 
                local CurrentWeight = GetCoffreWeight(faction)
                
                if not SharedFactions[faction].data["items"][item.name] then 
                    SharedFactions[faction].data["items"][item.name] = {}
                    SharedFactions[faction].data["items"][item.name].name = item.name 
                    SharedFactions[faction].data["items"][item.name].label = item.label
                    SharedFactions[faction].data["items"][item.name].count = qte
                    SharedFactions[faction].data["items"][item.name].itemWeight = item.weight
                else 
                    SharedFactions[faction].data["items"][item.name].count = SharedFactions[faction].data["items"][item.name].count + qte
                end

                xPlayer['inventory'].removeInventoryItem(item.name, qte)
                message = ("(Coffre Faction) **%s** à déposer **%s**x **%s**, faction **%s**"):format(GetPlayerName(source), qte, item.label, faction)
            else
                xPlayer.showNotification("~r~L'objet n'existe plus !")
            end
        else
            xPlayer.showNotification("~r~Montant Invalide !")
        end
    elseif type == 'item_weapon' then
        if xPlayer['loadout'].hasWeapon(item.name) then
            if not SharedFactions[faction].data["weapons"][item.name] then 
                SharedFactions[faction].data["weapons"][item.name] = {}
                SharedFactions[faction].data["weapons"][item.name].name = item.name 
                SharedFactions[faction].data["weapons"][item.name].label = item.label
                SharedFactions[faction].data["weapons"][item.name].ammo = item.ammo
                SharedFactions[faction].data["weapons"][item.name].components = item.components
                SharedFactions[faction].data["weapons"][item.name].tintIndex = item.tintIndex
                SharedFactions[faction].data["weapons"][item.name].count = 1
            else 
                SharedFactions[faction].data["weapons"][item.name].count = SharedFactions[faction].data["weapons"][item.name].count + 1
            end

            xPlayer['loadout'].removeWeapon(item.name)
            message = ("(Coffre Faction) **%s** à déposer **%s**, faction **%s**"):format(GetPlayerName(source), item.label, faction)
        else
            xPlayer.showNotification("~r~Vous n'avez pas cette Arme !")
        end
    end


    
    if message ~= nil then
        for k,v in pairs(SharedFactions) do 
            SaveFact(v.name, v.data, v.vehicle)
        end
        exports['Logs']:createLog({EmbedMessage = (message), player_id = source, channel = 'interactions'})
    end
end)

Factions.inRemoving = {}

RegisterServerEvent('factions:remove')
AddEventHandler('factions:remove', function(faction, type, item, qte)
    local message = nil;
    local xPlayer = Framework.GetPlayerFromId(source)

    if not Factions.inRemoving[faction] then
		Factions.inRemoving[faction] = true;
        if type == 'item_standard' then
            if xPlayer['inventory'].canCarryItem(item.name, qte) then
                if SharedFactions[faction].data["items"] and SharedFactions[faction].data["items"][item.name] then 
                    if tonumber(SharedFactions[faction].data["items"][item.name].count) >= tonumber(qte) then 
                        if (tonumber(SharedFactions[faction].data["items"][item.name].count) - tonumber(qte)) > 0 then 
                            SharedFactions[faction].data["items"][item.name].count = SharedFactions[faction].data["items"][item.name].count - qte
                        else 
                            SharedFactions[faction].data["items"][item.name] = nil
                        end
    
                        xPlayer['inventory'].addInventoryItem(item.name, tonumber(qte))
                        Factions.inRemoving[faction] = false;
                        message = ("(Coffre Faction) **%s** à retirer **%s**x **%s**, faction **%s**"):format(GetPlayerName(source), qte, item.label, faction)
                    else
                        Factions.inRemoving[faction] = false;
                        xPlayer.showNotification("~r~Il n'y a pas asser d'objets dans le coffre !")
                    end
                else
                    Factions.inRemoving[faction] = false;
                end
            else
                Factions.inRemoving[faction] = false;
                xPlayer.showNotification("~r~Vous n'avez pas asser de place sur vous !")
            end
        elseif type == 'item_weapon' then
            if not xPlayer['loadout'].hasWeapon(item.name) then
                if SharedFactions[faction].data["weapons"] and SharedFactions[faction].data["weapons"][item.name] then 
                    if tonumber(SharedFactions[faction].data["weapons"][item.name].count) >= 1 then 
                        if (tonumber(SharedFactions[faction].data["weapons"][item.name].count) - 1) > 0 then 
                            SharedFactions[faction].data["weapons"][item.name].count = SharedFactions[faction].data["weapons"][item.name].count - 1
                        else 
                            SharedFactions[faction].data["weapons"][item.name] = nil
                        end
    
                        xPlayer['loadout'].addWeapon(item.name, item.ammo)
                        Factions.inRemoving[faction] = false;
                        message = ("(Coffre Faction) **%s** à retirer **%s**, faction **%s**"):format(GetPlayerName(source), item.label, faction)
                    else
                        Factions.inRemoving[faction] = false;
                        xPlayer.showNotification("~r~Il n'y a pas asser d'objets dans le coffre !")
                    end
                else
                    Factions.inRemoving[faction] = false;
                end
            else
                Factions.inRemoving[faction] = false;
                xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
            end
        end
    else
		xPlayer.showNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
    end

    if message ~= nil then
        for k,v in pairs(SharedFactions) do 
            SaveFact(v.name, v.data, v.vehicle)
        end
        exports['Logs']:createLog({EmbedMessage = (message), player_id = source, channel = 'interactions'})
    end
end)