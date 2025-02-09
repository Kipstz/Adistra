
Bans = {}

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	local src = source
	local licenseid, playerip = 'N/A', 'N/A'
	licenseid = Framework.GetIdentifier(src)

	if not licenseid then
		setKickReason("License Invalide")
		CancelEvent()
	end

	deferrals.defer()
	Citizen.Wait(1)
	deferrals.update(('Vérification de %s en cours...'):format(playerName))
	Citizen.Wait(1)

	Bans.IsBanned(src, licenseid, function(isBanned, banData)
		if isBanned then
			if tonumber(banData.permanent) == 1 then
				deferrals.done(('Vous êtes banni de '.._Config.serverName2..'\nRaison : %s\nTemps Restant : Permanent\nAuteur : %s \nID de BAN : %s'):format(banData.raison, banData.author, banData.id))
			else
				if tonumber(banData.expiration) > os.time() then
					local timeRemaining = tonumber(banData.expiration) - os.time()
					deferrals.done(('Vous êtes banni de '.._Config.serverName2..'\nRaison : %s\nTemps Restant : %s\nAuteur : %s \nID de BAN : %s'):format(banData.raison, Bans.ConverterTime(timeRemaining), banData.author, banData.id))
				else
					Bans.DeleteBan(banData.id)
					deferrals.done()
				end
			end
		else
			deferrals.done()
		end
	end)
end)

Bans.IsBanned = function(source, licenseid, cb)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/bans.json") 

    banList = json.decode(loadFile)

    for k,v in pairs(banList) do
        if v.license == licenseid then
            cb(true, v)
        else
            for k2,v2 in pairs(v.tokens) do
                for i = 0, GetNumPlayerTokens(source) - 1 do
                    if v2 == GetPlayerToken(source, i) then
                        cb(true, v)
                    end
                end
            end
        end
    end

    cb(false)
end

Bans.ConverterTime = function(seconds)
	local days = seconds / 86400
	local hours = (days - math.floor(days)) * 24
	local minutes = (hours - math.floor(hours)) * 60
	seconds = (minutes - math.floor(minutes)) * 60
	return ('%s jours %s heures %s minutes %s secondes'):format(math.floor(days), math.floor(hours), math.floor(minutes), math.floor(seconds))
end

Bans.AddBan = function(source, characterId, license, tokens, steam, ip, discord, guid, xbl, targetName, sourceName, time, raison, permanent)
    local xPlayer = Framework.GetPlayerFromId(source)
    if xPlayer.group ~= 'user' then
        time = time * 3600 
        local timeat = os.time()
        local expiration = time + timeat
    
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/bans.json") 
    
        banList = json.decode(loadFile)
    
        date = os.date("%d").."/"..os.date("%m").."/"..os.date("%Y").." "..os.date("%X")
    
        table.insert(banList, {
            id = (#banList + 1),
            characterId = characterId,
            license = license,
            discord = discord,
            tokens = tokens,
            ip = ip,
            discord = discord,
            guid = guid,
            xbl = xbl,
            name = targetName,
            author = sourceName,
            expiration = expiration,
            raison = raison,
            permanent = permanent,
            date = date
        })
    
        SaveResourceFile(GetCurrentResourceName(), "./data/bans.json", json.encode(banList, {indent=true}), -1) 
    else
        print("TENTATIVE DE BAN PAR UN CHEATER")
    end
end

Bans.DeleteBan = function(idBan, cb)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/bans.json") 

    banList = json.decode(loadFile)

    for k,v in pairs(banList) do
        if v.id == idBan then
            table.remove(banList, k)
        end
    end

    SaveResourceFile(GetCurrentResourceName(), "./data/bans.json", json.encode(banList, {indent=true}), -1) 

    if cb then
        cb()
    end
end

RegisterCommand('ban', function(source, args)
    if source ~= 0 then
        local xPlayer = Framework.GetPlayerFromId(source)

        if xPlayer.group ~= 'user' then
            if args[1] ~= nil and (Framework.GetPlayerFromId(args[1]) ~= nil) then
                if args[2] ~= nil then
                    if args[3] ~= nil then
                        local tPlayer = Framework.GetPlayerFromId(args[1])
                        local expiration = tonumber(args[2])
                        local raison = table.concat(args, " ", 3)

                        sourceName = GetPlayerName(source)
                        targetName = GetPlayerName(tPlayer.source)

                        licenseid = tPlayer.identifier
                        characterId = tPlayer.characterId

                        if not licenseid then
                            licenseid = 'N/A'
                        end

                        local tokens = {}
                        local target = args[1]
                
                        for i = 0, GetNumPlayerTokens(target) - 1 do 
                            table.insert(tokens, GetPlayerToken(target, i))
                        end

                        for k, v in ipairs(GetPlayerIdentifiers(target)) do
                            if string.sub(v, 1,string.len("steam:")) == "steam:" then
                                steam  = v
                            elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
                                xbl = v
                            elseif string.sub(v,1,string.len("discord:")) == "discord:" then
                                discord = v
                            elseif string.sub(v, 1,string.len("ip:")) == "ip:" then
                                ip = v
                            end
                        end

                        if raison == '' then
                            raison = 'Non-Défini'
                        end

                        if expiration > 0 then
                            Bans.AddBan(source, characterId, licenseid, tokens, steam, ip, discord, guid, xbl, targetName, sourceName, expiration, raison, false)

                            DropPlayer(args[1], ('Vous êtes banni de '.._Config.serverName2..'\nRaison : %s\nTemps Restant : %s\nAuteur : %s'):format(raison, Bans.ConverterTime(expiration * 3600), sourceName))
                            xPlayer.showNotification(("Vous avez ban [~b~%s~s~] - %s pendant %s pour %s"):format(tPlayer.source, targetName, Bans.ConverterTime(expiration*3600), raison))
                            exports['Logs']:createLog({EmbedMessage = ("**%s** à BAN [**%s**] - **%s** pendant **%s** pour **%s**."):format(tPlayer.source, targetName, Bans.ConverterTime(expiration*3600), raison), player_id = xPlayer.source, player_2_id = tPlayer.source, channel = 'bans'})
                        else
							Bans.AddBan(source, characterId, licenseid, tokens, steam, ip, discord, guid, xbl, targetName, sourceName, 57576465746754765567467548567457645764, raison, true)

							DropPlayer(args[1], ('Vous êtes banni de '.._Config.serverName2..'\nRaison : %s\nTemps Restant : Permanent\nAuteur : %s'):format(raison, sourceName))
                            xPlayer.showNotification(("Vous avez ban [~b~%s~s~] - %s de façon permanente pour %s"):format(tPlayer.source, targetName, raison))
                            exports['Logs']:createLog({EmbedMessage = ("**%s** à BAN [**%s**] - **%s** de façon permanente pour **%s**."):format(tPlayer.source, targetName, raison), player_id = xPlayer.source, player_2_id = tPlayer.source, channel = 'bans'})
                        end
                    else
                        xPlayer.showNotification("~r~Veuillez saisir une raison de ban !")
                    end
                else
                    xPlayer.showNotification("~r~Veuillez saisir une temps de ban !")
                end
            else
                xPlayer.showNotification("~r~Veuillez saisir un ID valide !")
            end
        end
    else
        if args[1] ~= nil and (Framework.GetPlayerFromId(args[1]) ~= nil) then
            if args[2] ~= nil then
                if args[3] ~= nil then
                    local tPlayer = Framework.GetPlayerFromId(args[1])
                    local expiration = tonumber(args[2])
                    local raison = table.concat(args, " ", 3)

                    targetName = GetPlayerName(tPlayer.source)

                    licenseid = tPlayer.identifier
                    characterId = tPlayer.characterId

                    local tokens = {}
                    local target = args[1]
            
                    for i = 0, GetNumPlayerTokens(target) - 1 do 
                        table.insert(tokens, GetPlayerToken(target, i))
                    end

                    if not licenseid then
                        licenseid = 'N/A'
                    end

                    if raison == '' then
                        raison = 'Non-Défini'
                    end

                    if expiration > 0 then
                        Bans.AddBan(nil, characterId, licenseid, tokens, steam, ip, discord, guid, xbl, targetName, "Console", expiration, raison, false)

                        DropPlayer(args[1], ('Vous êtes banni de '.._Config.serverName2..'\nRaison : %s\nTemps Restant : %s\nAuteur : %s'):format(raison, Bans.ConverterTime(expiration * 3600), "Console"))
                        print(("Vous avez ban [^4%s^0] - %s pendant %s pour %s"):format(tPlayer.source, targetName, Bans.ConverterTime(expiration*3600), raison))
                        exports['Logs']:createLog({EmbedMessage = ("CONSOLE à BAN [**%s**] - **%s** pendant **%s** pour **%s**."):format(tPlayer.source, targetName, Bans.ConverterTime(expiration*3600), raison), player_2_id = tPlayer.source, channel = 'bans'})
                    else
                        Bans.AddBan(nil, characterId, licenseid, tokens, steam, ip, discord, guid, xbl, targetName, "Console", expiration, raison, true)

                        DropPlayer(args[1], ('Vous êtes banni de '.._Config.serverName2..'\nRaison : %s\nTemps Restant : Permanent\nAuteur : %s'):format(raison, "Console"))
                        print(("Vous avez ban [^4%s^0] - %s de façon permanente pour %s"):format(tPlayer.source, targetName, raison))
                        exports['Logs']:createLog({EmbedMessage = ("CONSOLE à BAN [**%s**] - **%s** de façon permanente pour **%s**."):format(tPlayer.source, targetName, raison), player_2_id = tPlayer.source, channel = 'bans'})
                    end
                else
                    print("[^1BAN^0] Veuillez saisir une raison de ban !")
                end
            else
                print("[^1BAN^0] Veuillez saisir une temps de ban !")
            end
        else
            print("[^1BAN^0] Veuillez saisir un ID valide !")
        end
    end
end)

Framework.RegisterCommand('unban', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
    local success = false
	if xPlayer then
		source = xPlayer.source
		sourceName = GetPlayerName(xPlayer.source)
	else
		sourceName = "Console"
	end

	if args.idBan ~= nil and args.idBan > 0 then
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/bans.json") 

        banList = json.decode(loadFile)

        for k,v in pairs(banList) do
            if v.id == args.idBan then
				Bans.DeleteBan(args.idBan, function()
                    if xPlayer then
                        xPlayer.showNotification("Vous avez unban l'Id de ban ~b~"..args.idBan.."~s~ !")
                        exports['Logs']:createLog({EmbedMessage = ("**%s** à UNBAN l'id de ban **%s**."):format(xPlayer.getName(), args.idBan), player_id = xPlayer.source, channel = 'bans'})
                    else
                        print("Vous avez unban l'Id de ban ^4"..args.idBan.."^0 !")
                        exports['Logs']:createLog({EmbedMessage = ("CONSOLE à UNBAN l'id de ban **%s**."):format(xPlayer.getName(), args.idBan), player_id = xPlayer.source, channel = 'bans'})
                    end

                    success = true
				end)
            end
		end

        Wait(500)

        if not success then
            if xPlayer then
                xPlayer.showNotification("~r~Id de ban Invalide !")
            else
                print("^1 ID de BAN invalide !^0")
            end
        end
	else
        if xPlayer then
            xPlayer.showNotification("~r~Id de ban Invalide !")
        else
            print("^1 ID de BAN invalide !^0")
        end
	end
end, true, {help = "Deban un Joueur", validate = true, arguments = {
	{name = 'idBan', help = "ID de BAN", type = 'number'}
}})

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

    TriggerClientEvent('chat:addSuggestion', src, '/ban', 'Bannir un joueur', {
        { name="playerId", help="ID du Joueur" },
        { name="expiration", help="Expiration du ban (en heures, 0 pour perm)" },
        { name="raison", help="Raison du Ban" }
    })
end)