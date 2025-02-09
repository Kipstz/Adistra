
Property = {}
SharedProperty = {}
PropertyLoaded = false;

Framework.RegisterServerCallback("property:getProperties", function(src, cb)
    local src = src;
    local xPlayer = Framework.GetPlayerFromId(src)
    while xPlayer == nil do Wait(3000) end
    Property.properties, Property.owneds = {}, {}

    MySQL.query("SELECT * FROM properties", function(data)
        for k,v in pairs(data) do
            MySQL.query("SELECT * FROM character_properties WHERE id_property = ?", {v.id}, function(result2)
                if not next(result2) then
                    table.insert(Property.properties, {
                        id = v.id,
                        params = json.decode(v.params),
                        points = json.decode(v.points),
                        owned = false,
                        owners = nil
                    })
                else
                    table.insert(Property.properties, {
                        id = v.id,
                        params = json.decode(v.params),
                        points = json.decode(v.points),
                        owned = true,
                        owners = json.decode(result2[1].owners)
                    })

                    for k2,v2 in pairs(json.decode(result2[1].owners)) do
                        if v2 == xPlayer.characterId then
                            table.insert(Property.owneds, {
                                id = v.id,
                                params = json.decode(v.params),
                                points = json.decode(v.points),
                                data = json.decode(result2[1].data),
                                owners = json.decode(result2[1].owners)
                            })
                        end
                    end
                end
            end)
        end
    end)
    Wait(1500)
    InitSharedProperties()
    cb(Property.properties, Property.owneds)
end)

Framework.RegisterServerCallback("property:getProperty", function(src, cb, idProperty)
    local xPlayer = Framework.GetPlayerFromId(src)
    
    property, owneds = {}, {}

    MySQL.query("SELECT * FROM properties WHERE id = ?", {idProperty}, function(data)
        for k,v in pairs(data) do
            MySQL.query("SELECT * FROM character_properties WHERE id_property = ?", {idProperty}, function(result2)
                if not next(result2) then
                    property = {
                        id = v.id,
                        params = json.decode(v.params),
                        points = json.decode(v.points),
                        owned = false,
                        owners = nil
                    }
                else
                    property = {
                        id = v.id,
                        params = json.decode(v.params),
                        points = json.decode(v.points),
                        owned = true,
                        owners = json.decode(result2[1].owners)
                    }

                    for k2,v2 in pairs(json.decode(result2[1].owners)) do
                        if v2 == xPlayer.characterId then
                            owneds = {
                                id = v.id,
                                params = json.decode(v.params),
                                points = json.decode(v.points),
                                data = json.decode(result2[1].data),
                                owners = json.decode(result2[1].owners)
                            }
                        end
                    end
                end
            end)
        end
    end)
    Wait(1500)
    cb(property, owneds)
end)

RegisterNetEvent('property:reloadProperties')
AddEventHandler('property:reloadProperties', function(source)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    while xPlayer == nil do Wait(3000) end

    Property.properties, Property.owneds = {}, {}

    MySQL.query("SELECT * FROM properties", function(data)
        for k,v in pairs(data) do
            MySQL.query("SELECT * FROM character_properties WHERE id_property = ?", {v.id}, function(result2)
                if not next(result2) then
                    table.insert(Property.properties, {
                        id = v.id,
                        params = json.decode(v.params),
                        points = json.decode(v.points),
                        owned = false,
                        owners = nil
                    })
                else
                    table.insert(Property.properties, {
                        id = v.id,
                        params = json.decode(v.params),
                        points = json.decode(v.points),
                        owned = true,
                        owners = json.decode(result2[1].owners)
                    })

                    for k2,v2 in pairs(json.decode(result2[1].owners)) do
                        if v2 == xPlayer.characterId then
                            table.insert(Property.owneds, {
                                id = v.id,
                                params = json.decode(v.params),
                                points = json.decode(v.points),
                                data = json.decode(result2[1].data),
                                owners = json.decode(result2[1].owners)
                            })
                        end
                    end
                end
            end)
        end
    end)
    Wait(1500)
    InitSharedProperties()
end)

RegisterNetEvent("property:sonne")
AddEventHandler("property:sonne", function(target)
    local player = Framework.GetPlayerFromId(target)

    player.showNotification("~b~Une Personne à Sonner à la porte !")
end)

Framework.RegisterServerCallback("property:getLastProperty", function(src, cb)
	local xPlayer = Framework.GetPlayerFromId(src)

	local result = MySQL.query.await('SELECT last_property FROM characters WHERE characterId = ?', {xPlayer.characterId})
    cb(result[1].last_property)
end)

RegisterNetEvent("property:saveLastProperty")
AddEventHandler("property:saveLastProperty", function(propertyId)
    local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

	MySQL.query('UPDATE characters SET last_property = @last_property WHERE characterId = @characterId', {
		['@last_property'] = propertyId,
		['@characterId'] = xPlayer.characterId
	})
end)

RegisterNetEvent("property:deleteLastProperty")
AddEventHandler("property:deleteLastProperty", function()
	local xPlayer = Framework.GetPlayerFromId(source)

	MySQL.query('UPDATE characters SET last_property = NULL WHERE characterId = @characterId', {
		['@characterId'] = xPlayer.characterId
	})
end)
