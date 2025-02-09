
Jail = {}

RegisterCommand('jail', function(source, args)
    if source ~= 0 then
        local xPlayer = Framework.GetPlayerFromId(source)

        if xPlayer.group ~= 'user' then
            if args[1] and (Framework.GetPlayerFromId(args[1]) ~= nil) then
                if args[2] ~= nil then
                    if args[3] ~= nil then
                        local tPlayer = Framework.GetPlayerFromId(args[1])
                        local jailTime = tonumber(args[2])
                        local raison = table.concat(args, " ", 3)
        
                        tPlayer.triggerEvent("jail:sendtoJail", jailTime, raison)
                        Jail.SendJail(tPlayer, jailTime, raison)
                        exports['Logs']:createLog({EmbedMessage = ("**%s** à Jail **%s** pour **%s** pendant **%s** Minutes"):format(GetPlayerName(source), GetPlayerName(args[1]), raison, jailTime), player_id = source, player_2_id = args[1], channel = 'jails'})
                    else
                        xPlayer.showNotification("Veuillez saisir une Raison !")
                    end
                else
                    xPlayer.showNotification("Veuillez saisir le temps du Jail !")
                end
            else
                xPlayer.showNotification("Veuillez saisir un ID valide !")
            end
        else
            xPlayer.showNotification("Vous n'avez pas accès a cette commande !")
        end
    else
        if args[1] and (Framework.GetPlayerFromId(args[1]) ~= nil) then
            if args[2] ~= nil then
                if args[3] ~= nil then
                    local tPlayer = Framework.GetPlayerFromId(args[1])
                    local jailTime = tonumber(args[2])
                    local raison = table.concat(args, " ", 3)
    
                    tPlayer.triggerEvent("jail:sendtoJail", jailTime, raison)
                    Jail.SendJail(tPlayer, jailTime, raison)
                    exports['Logs']:createLog({EmbedMessage = ("CONSOLE à Jail **%s** pour **%s** pendant **%s** Minutes"):format(GetPlayerName(args[1]), raison, jailTime), player_id = args[1], channel = 'jails'})
                else
                    print("Veuillez saisir une Raison !")
                end
            else
                print("Veuillez saisir le temps du Jail !")
            end
        else
            print("Veuillez saisir un ID valide !")
        end
    end
end, false)

Framework.RegisterCommand('unjail', { 'mod', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
    exports['Logs']:createLog({EmbedMessage = ("**%s** a UNJail **%s**"):format(GetPlayerName(xPlayer.source), GetPlayerName(args.playerId.source)), player_id = xPlayer.source, player_2_id = args.playerId.source, channel = 'unjails'})
    
    args.playerId.triggerEvent("jail:unjail")
end, true, {help = "Unjail un Joueur", validate = true, arguments = {
	{name = 'playerId', help = "ID du Joueur", type = 'player'},
}})

Jail.SendJail = function(xPlayer, jailTime, raison)
    local result = MySQL.query.await('SELECT * FROM jails WHERE identifier = ?', {xPlayer.identifier})

    if result[1] == nil and jailTime ~= nil then
        MySQL.query("INSERT INTO jails (identifier, jailTime, raison) VALUES (@identifier, @jailTime, @raison)", {
            ['@identifier'] = xPlayer.identifier,
            ['@jailTime'] = jailTime,
            ['@raison'] = raison
        })
    end
end
--[[
RegisterNetEvent('framework:playerLoaded')
AddEventHandler('framework:playerLoaded', function(source, xPlayer)]]
RegisterNetEvent('characters:selectedCharacter')
AddEventHandler('characters:selectedCharacter', function()
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)
    Citizen.Wait(5000)
    TriggerClientEvent('chat:addSuggestion', _source, '/jail', 'Jail un joueur', {
        { name="playerId", help="ID du Joueur" },
        { name="time", help="Temps du Jail (en min)" },
        { name="raison", help="Raison du Jail" }
    })

    local result = MySQL.query.await('SELECT * FROM jails WHERE identifier = ?', {xPlayer.identifier})

    if result[1] and result[1] ~= nil then
        xPlayer.triggerEvent("jail:sendtoJail", result[1].jailTime, result[1].raison)
    end
end)

RegisterNetEvent("jail:updateTime")
AddEventHandler("jail:updateTime", function(jailTime)
    local xPlayer = Framework.GetPlayerFromId(source)

    MySQL.query("UPDATE jails SET jailTime = @jailTime WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@jailTime'] = jailTime
    })
end)

RegisterNetEvent("jail:unjail")
AddEventHandler("jail:unjail", function()
    local xPlayer = Framework.GetPlayerFromId(source)

    MySQL.query("DELETE FROM jails WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    })
end)