
AgentImmoJob = {}
AgentImmoJob.inTimeout = false

function AgentImmoJob:calculatePrice(price)
    local tauxMarge = 0.25;
    local priceSell = price * (1 + tauxMarge)
    return tonumber(priceSell)
end

RegisterServerEvent('bossManagement:annonce')
AddEventHandler('bossManagement:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not AgentImmoJob.inTimeout then
        TriggerClientEvent('framework:showAdvancedNotification', -1, "Entreprise", '~b~Annonce', annonce)

        AgentImmoJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)

AgentImmoJob.startTimeout = function(time)
    AgentImmoJob.inTimeout = true
    
    SetTimeout(time, function()
        AgentImmoJob.inTimeout = false
    end)
end

RegisterServerEvent("AgentImmoJob:createBuilder")
AddEventHandler("AgentImmoJob:createBuilder", function(builder)
    local xPlayer = Framework.GetPlayerFromId(source)

    MySQL.query("INSERT INTO properties (params, points) VALUES (?, ?)", {json.encode(builder.params), json.encode(builder.points)}, function(rowsChanged)
        xPlayer.showNotification("~g~La propriété a été créer !")

        data = {
            id = rowsChanged.insertId,
            params = builder.params,
            points = builder.points,
            owned = false,
            owners = nil
        }

        TriggerClientEvent('property:addProperty', -1, data)
        TriggerEvent('property:reloadProperties')
    end)
end)

RegisterServerEvent("AgentImmoJob:addOwner")
AddEventHandler("AgentImmoJob:addOwner", function(target, rented, property)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(target)

    local data = {
        vehicles = {},
        coffre = { accounts = { money = 0, black_money = 0 }, items = {}, weapons = {} }
    }

    if rented then
        local price = AgentImmoJob:calculatePrice(tonumber(property[1].params.priceLoc))

        TriggerEvent('bossManagement:getSocietyAccount', 'agentimmo', function(accountMoney)
            if accountMoney >= tonumber(property[1].params.priceLoc) then
                if tPlayer['accounts'].getAccount('bank').money >= tonumber(property[1].params.priceLoc) then
                    TriggerEvent('bossManagement:removeMoneybyOther', 'agentimmo', tonumber(property[1].params.priceLoc))
                    TriggerEvent('bossManagement:depositMoneybyOther', 'agentimmo', price)
                    tPlayer['accounts'].removeAccountMoney('bank', price)

                    MySQL.query("INSERT INTO character_properties (id_property, rented, owners, data) VALUES (?, ?, ?, ?)", {
                        property[1].id_property, true, json.encode({tPlayer.characterId}), json.encode(data)
                    })
                else
                    tPlayer.showNotification("~r~Vous n'avez pas asser d'argent !~s~")
                end
            else
                xPlayer.showNotification("~r~La société n'a pas asser d'argent !")
            end
        end)
    else
        local price = AgentImmoJob:calculatePrice(tonumber(property[1].params.priceVente))

        TriggerEvent('bossManagement:getSocietyAccount', 'agentimmo', function(accountMoney)
            if accountMoney >= tonumber(property[1].params.priceVente) then
                if tPlayer['accounts'].getAccount('bank').money >= tonumber(property[1].params.priceVente) then
                    TriggerEvent('bossManagement:removeMoneybyOther', 'agentimmo', tonumber(property[1].params.priceVente))
                    TriggerEvent('bossManagement:depositMoneybyOther', 'agentimmo', price)
                    tPlayer['accounts'].removeAccountMoney('bank', price)

                    MySQL.query("INSERT INTO character_properties (id_property, rented, owners, data) VALUES (?, ?, ?, ?)", {
                        property[1].id_property, false, json.encode({tPlayer.characterId}), json.encode(data)
                    })
                else
                    tPlayer.showNotification("~r~Vous n'avez pas asser d'argent !~s~")
                end
            else
                xPlayer.showNotification("~r~La société n'a pas asser d'argent !")
            end
        end)
    end

    xPlayer.showNotification("Vous avez attribué une propriété")
    tPlayer.showNotification("Vous avez une nouvelle propriété")
    TriggerClientEvent('property:updateOwner', -1, property[1].id_property)
    TriggerEvent('property:reloadProperties', target)
end)

RegisterServerEvent("AgentImmoJob:removeOwner")
AddEventHandler("AgentImmoJob:removeOwner", function(propertyId)
    local xPlayer = Framework.GetPlayerFromId(source)

    local data = {
        vehicles = {},
        coffre = { accounts = { money = 0, black_money = 0 }, items = {}, weapons = {} }
    }

    MySQL.query("DELETE FROM character_properties WHERE id_property = ?", {propertyId})
    xPlayer.showNotification("Vous avez supprimé le propriétaire de la propriété")
    TriggerClientEvent('property:updateOwner', -1, propertyId)
    TriggerEvent('property:reloadProperties')
end)

RegisterServerEvent("AgentImmoJob:addSubOwner")
AddEventHandler("AgentImmoJob:addSubOwner", function(target, property)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(target)

    MySQL.query("SELECT owners FROM character_properties WHERE id_property = ?", {property[1].id_property}, function(result)
        local can = true;
        local owners = json.decode(result[1].owners)
        for k,v in pairs(owners) do
            if v == tPlayer.characterId then can = false; end
        end
        if can then table.insert(owners, tPlayer.characterId) end
        MySQL.query("UPDATE character_properties SET owners = ? WHERE id_property = ?", {json.encode(owners), property[1].id_property})
    end)

    xPlayer.showNotification("Vous avez attribué une propriété")
    tPlayer.showNotification("Vous avez une nouvelle propriété")
    TriggerClientEvent('property:updateOwner', -1, property[1].id_property)
    TriggerEvent('property:reloadProperties', target)
end)

RegisterServerEvent("AgentImmoJob:removeSubOwner")
AddEventHandler("AgentImmoJob:removeSubOwner", function(target, propertyId)
    local xPlayer = Framework.GetPlayerFromId(source)
    local tPlayer = Framework.GetPlayerFromId(target)

    local data = {
        vehicles = {},
        coffre = { accounts = { money = 0, black_money = 0 }, items = {}, weapons = {} }
    }

    MySQL.query("SELECT owners FROM character_properties WHERE id_property = ?", {propertyId}, function(result)
        local owners = json.decode(result[1].owners)
        for k,v in pairs(owners) do
            if v == tPlayer.characterId then table.remove(owners, k) end
        end
        if owners ~= nil and next(owners) then
            MySQL.query("UPDATE character_properties SET owners = ? WHERE id_property = ?", {json.encode(owners), propertyId})
        else
            MySQL.query("DELETE FROM character_properties WHERE id_property = ?", {propertyId})
        end
    end)
    xPlayer.showNotification("Vous avez supprimé le co-propriétaire de la propriété")
    TriggerClientEvent('property:updateOwner', -1, propertyId)
    TriggerEvent('property:reloadProperties')
end)

RegisterServerEvent("AgentImmoJob:deleteProperty")
AddEventHandler("AgentImmoJob:deleteProperty", function(propertyId)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    MySQL.query("DELETE FROM properties WHERE id = ?", {propertyId})
    MySQL.query("DELETE FROM character_properties WHERE id_property = ?", {propertyId})
    xPlayer.showNotification("Vous avez ~r~supprimé~s~ une propriété")
    TriggerClientEvent('property:removeProperty', -1, propertyId)
    TriggerEvent('property:reloadProperties')
end)