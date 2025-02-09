
MySQL.ready(function()
	MySQL.Async.execute('DELETE FROM characters WHERE identity IS NULL and skin IS NULL')
end)

RegisterNetEvent("framework:playerLoaded")
AddEventHandler("framework:playerLoaded", function(src, xPlayer, isNew)
    local src, xPlayer, isNew = src, xPlayer, isNew;

    if isNew then
        local id = MySQL.insert.await('INSERT INTO `characters` (identifier) VALUES (?)', {
            xPlayer.identifier
        })

        xPlayer.setCharacterId(id)
        xPlayer.triggerEvent('characters:init', id)
    else
        local characters = {}
        local result = MySQL.query.await('SELECT `characterId`, `identity` FROM `characters` WHERE `identifier` = ?', {
            xPlayer.identifier
        })

        if result and next(result) then
            for i = 1, #result do
                local row = result[i]
                if row.identity ~= nil then
                    table.insert(characters, {
                        characterId = row.characterId,
                        identity = json.decode(row.identity)
                    })
                end
            end

            Wait(100)
            xPlayer.triggerEvent('characters:selectCharacter', characters)
        else
            local id = MySQL.insert.await('INSERT INTO `characters` (identifier) VALUES (?)', {
                xPlayer.identifier
            })
    
            xPlayer.setCharacterId(id)
            xPlayer.triggerEvent('characters:init', id)
        end
    end
end)

RegisterNetEvent('characters:createCharacter')
AddEventHandler('characters:createCharacter', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    local id = MySQL.insert.await('INSERT INTO `characters` (identifier) VALUES (?)', {
        xPlayer.identifier
    })

    xPlayer.setCharacterId(id)
    xPlayer.triggerEvent('characters:createCharacter', id)
end)

RegisterNetEvent('characters:selectedCharacter')
AddEventHandler('characters:selectedCharacter', function(character)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    xPlayer.setCharacterId(character.characterId)
    TriggerEvent('framework:restoreCharacter', src, character.characterId)
    TriggerEvent('SnailCore:restoreChar', src)
end)

RegisterNetEvent('characters:save')
AddEventHandler('characters:save', function(characterId, identity)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    local identity = {
        firstname = identity.prenom,
        lastname = identity.nom,
        dateofbirth = identity.ddn,
        sex = identity.sexe,
        height = identity.taille
    }

    MySQL.update.await('UPDATE characters SET identity = ? WHERE characterId = ?', {
        json.encode(identity), characterId
    })

    xPlayer.setCharacterId(characterId)
    TriggerEvent('framework:restoreCharacter', src, characterId)
end)

-- Framework.RegisterCommand('delchar', {'superadmin', 'owner'}, function(xPlayer, args, showError)
--     local rowsChanged = MySQL.update.await("DELETE FROM characters WHERE characterId = ?", {args.characterId})

--     if rowsChanged == 1 then
--         if xPlayer then
--             xPlayer.showNotification("Le personnage avec l'id ~r~"..args.characterId.."~s~ a été supprimer !")
--         else
--             print("^0Le personnage avec l'id ^1"..args.characterId.."^0 a été supprimer !")
--         end
--     else
--         if xPlayer then
--             xPlayer.showNotification("~r~Le personnage avec l'id ~b~"..args.characterId.."~r~ n'existe pas !")
--         else
--             print("^1Le personnage avec l'id ^3"..args.characterId.."^1 n'existe pas !")
--         end
--     end 
-- end, true, {help = "Supprimer un Personnage", validate = true, arguments = {
-- 	{name = 'characterId', help = "ID du Personnage", type = 'number'},
-- }})

RegisterNetEvent('selector:banFreecam')
AddEventHandler('selector:banFreecam', function(playerCoords, distance)
    local _source = source

    exports['ac']:screenshotPlayer(_source, function(url)
        print('got url of screnshot: '..url..' from player: '.._source)
    end)
    Citizen.Wait(5000)
    exports['ac']:fg_BanPlayer(_source, 'Anti-freecam ('..playerCoords..' | '..distance..')', true)
end)