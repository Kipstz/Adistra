local function GetIdentifierOutfits(id)
    local outfits = {}

    MySQL.query("SELECT * FROM character_outfits WHERE characterId = ?", {id}, function(result)
        for k,v in pairs(result) do
            table.insert(outfits, {
                id = v.id,
                characterId = v.characterId,
                outfit = json.decode(v.outfit),
                name = v.name
            })
        end
    end)

    Wait(1500)

    return outfits
end

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
    local myOutfits = GetIdentifierOutfits(xPlayer.characterId)
    xPlayer.triggerEvent('shop_clothe:updateOutfits', myOutfits)
end)

RegisterNetEvent('shop_clothe:buy')
AddEventHandler('shop_clothe:buy', function(name, outfit)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['accounts'].getMoney() >= 350 then
        xPlayer['accounts'].removeMoney(350)

        MySQL.query("INSERT INTO character_outfits (`characterId`, `outfit`, `name`) VALUES (?, ?, ?)", {
            xPlayer.characterId, json.encode(outfit), name
        })

        Wait(500)

        local myOutfits = GetIdentifierOutfits(xPlayer.characterId)
        xPlayer.triggerEvent('shop_clothe:updateOutfits', myOutfits)
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterNetEvent('shop_clothe:pay')
AddEventHandler('shop_clothe:pay', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['accounts'].getMoney() >= 350 then
        xPlayer['accounts'].removeMoney(350)
    else
        xPlayer.triggerEvent('skinchanger:reloadSkinPlayer')
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterNetEvent('shop_clothe:donnerOutfit')
AddEventHandler('shop_clothe:donnerOutfit', function(target, outfitId)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local xTarget = Framework.GetPlayerFromId(target)

    MySQL.query("UPDATE character_outfits SET characterId = ? WHERE characterId = ? AND id = ?", {xTarget.characterId, xPlayer.characterId, outfitId})

    Wait(500)
    
    local myOutfits = GetIdentifierOutfits(xPlayer.characterId)
    xPlayer.triggerEvent('shop_clothe:updateOutfits', myOutfits)
    local targetOutfits = GetIdentifierOutfits(xTarget.characterId)
    xTarget.triggerEvent('shop_clothe:updateOutfits', targetOutfits)
end)

RegisterNetEvent('shop_clothe:deleteOutfit')
AddEventHandler('shop_clothe:deleteOutfit', function(outfitId)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    MySQL.query("DELETE FROM character_outfits WHERE characterId = ? AND id = ?", {xPlayer.characterId, outfitId})

    Wait(500)
    
    local myOutfits = GetIdentifierOutfits(xPlayer.characterId)
    xPlayer.triggerEvent('shop_clothe:updateOutfits', myOutfits)
end)