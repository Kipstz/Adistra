
local function GetIdentifierAccessories(id)
    local accessories = {}

    MySQL.query("SELECT * FROM character_accessories WHERE characterId = ?", {id}, function(result)
        for k,v in pairs(result) do
            table.insert(accessories, {
                id = v.id,
                characterId = v.characterId,
                cat = v.cat,
                key = v.key,
                val = v.val,
                name = v.name
            })
        end
    end)

    Wait(1500)

    return accessories
end

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
    local myAccessories = GetIdentifierAccessories(xPlayer.characterId)
    xPlayer.triggerEvent('shop_accessories:updateAccessories', myAccessories)
end)

RegisterNetEvent('shop_accessories:buy')
AddEventHandler('shop_accessories:buy', function(name, cat, key, val)
    local xPlayer = Framework.GetPlayerFromId(source)

    if name ~= nil and cat ~= nil and key ~= nil and val ~= nil then
        if xPlayer['accounts'].getMoney() >= 700 then
            xPlayer['accounts'].removeMoney(700)
    
            MySQL.query("INSERT INTO character_accessories (`characterId`, `cat`, `key`, `val`, `name`) VALUES (?, ?, ?, ?, ?)", {
                xPlayer.characterId, cat, key, val, name
            })
    
            Wait(500)
    
            local myAccessories = GetIdentifierAccessories(xPlayer.characterId)
            xPlayer.triggerEvent('shop_accessories:updateAccessories', myAccessories)
        else
            xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
        end
    end
end)

RegisterNetEvent('shop_accessories:donnerAccessorie')
AddEventHandler('shop_accessories:donnerAccessorie', function(target, accessorieId)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local xTarget = Framework.GetPlayerFromId(target)

    MySQL.query("UPDATE character_accessories SET characterId = ? WHERE characterId = ? AND id = ?", {xTarget.characterId, xPlayer.characterId, accessorieId})

    Wait(500)
    
    local myAccessories = GetIdentifierAccessories(xPlayer.characterId)
    xPlayer.triggerEvent('shop_accessories:updateAccessories', myAccessories)
    local targetAccessories = GetIdentifierAccessories(xTarget.characterId)
    xTarget.triggerEvent('shop_accessories:updateAccessories', targetAccessories)
end)

RegisterNetEvent('shop_accessories:deleteAccessorie')
AddEventHandler('shop_accessories:deleteAccessorie', function(accessorieId)
    local xPlayer = Framework.GetPlayerFromId(source)

    MySQL.query("DELETE FROM character_accessories WHERE characterId = ? AND id = ?", {xPlayer.characterId, accessorieId})

    Wait(500)
    
    local myAccessories = GetIdentifierAccessories(xPlayer.characterId)
    xPlayer.triggerEvent('shop_accessories:updateAccessories', myAccessories)
end)