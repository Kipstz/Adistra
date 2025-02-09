
function Framework.RegisterCommand(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for k,v in ipairs(name) do
			Framework.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if Framework.RegisteredCommands[name] then
		print(('[^3WARNING^7] Command ^5"%s" already registered, overriding command'):format(name))

		if Framework.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then suggestion.arguments = {} end
		if not suggestion.help then suggestion.help = '' end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	Framework.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

	RegisterCommand(name, function(playerId, args, rawCommand)
		local command = Framework.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
			print(('[^3WARNING^7] ^5%s'):format("Cette commande ne peut être utilisée uniquement via la console !"))
		else
			local xPlayer, error, byPassArgs = Framework.GetPlayerFromId(playerId), nil, false

			if command.suggestion then
				for k,v in ipairs(command.suggestion.arguments) do
					if v.type == 'player' or v.type == 'playerId' then
						byPassArgs = true
					end
				end

				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments and not byPassArgs then
						error = _U('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k,v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' or args[k] == nil then targetPlayer = playerId end

								if targetPlayer then
									local xTargetPlayer = Framework.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = "Id de joueur Invalide"
									end
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								newArgs[v.name] = args[k]
							elseif v.type == 'item' then
								if Framework.ITEMS.List[args[k]] then
									newArgs[v.name] = args[k]
								else
									error = "Item Invalide"
								end
							elseif v.type == 'weapon' then
								if Framework.GetWeapon(args[k]) then
									newArgs[v.name] = string.upper(args[k])
								else
									error = "Arme Invalide"
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							end
						end

						if error then break end
					end

					args = newArgs
				end
			end

			if error then
				if playerId == 0 then
					print(('[^3WARNING^7] %s^7'):format(error))
				else
					xPlayer.showNotification(error)
				end
			else
				cb(xPlayer or false, args, function(msg)
					if playerId == 0 then
						print(('[^3WARNING^7] %s^7'):format(msg))
					else
						xPlayer.showNotification(msg)
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for k,v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

function Framework.RegisterServerCallback(name, cb)
	Framework.ServerCallbacks[name] = cb
end

function Framework.TriggerServerCallback(name, requestId, source, cb, ...)
	if Framework.ServerCallbacks[name] then
		Framework.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
	end
end

function Framework.ReloadItems()
	local items = MySQL.query.await('SELECT * FROM items')
	for k, v in ipairs(items) do
		Framework.ITEMS.List[v.name] = {
			label = v.label,
			weight = v.weight,
			canRemove = v.can_remove
		}
	end
end

function Framework.ReloadJobs()
	local Jobs = {}
	local jobs = MySQL.query.await('SELECT * FROM jobs')

	for _, v in ipairs(jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end

	local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

	for _, v in ipairs(jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
		end
	end

	for _, v in pairs(Jobs) do
		if Framework.Table.SizeOf(v.grades) == 0 then
			Jobs[v.name] = nil
			print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v.name))
		end
	end

	if not Jobs then
		Framework.JobsList['unemployed'] = {
			label = 'Unemployed',
			grades = {
				['0'] = {
					grade = 0,
					name = 'unemployed',
					label = 'Unemployed',
				}
			}
		}
	else
		Framework.JobsList = Jobs
	end

	local Jobs2 = {}
	local jobs2 = MySQL.query.await('SELECT * FROM jobs2')

	for _, v in ipairs(jobs2) do
		Jobs2[v.name] = v
		Jobs2[v.name].grades = {}
	end

	local job2Grades = MySQL.query.await('SELECT * FROM job2_grades')

	for _, v in ipairs(job2Grades) do
		if Jobs2[v.job2_name] then
			Jobs2[v.job2_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job2 grades for ^5"%s"^0 due to missing job2'):format(v.job2_name))
		end
	end

	for _, v in pairs(Jobs2) do
		if Framework.Table.SizeOf(v.grades) == 0 then
			Jobs2[v.name] = nil
			print(('[^3WARNING^7] Ignoring job2 ^5"%s"^0due to no job2 grades found'):format(v.name))
		end
	end

	if not Jobs2 then
		Framework.Jobs2List['unemployed2'] = {
			label = 'Unemployed2',
			grades = {
				['0'] = {
					grade = 0,
					name = 'unemployed2',
					label = 'Unemployed2',
				}
			}
		}
	else
		Framework.Jobs2List = Jobs2
	end
end

exports('ReloadItems', function() Framework.ReloadItems() end)
exports('ReloadJobs', function() Framework.ReloadJobs() end)

function Framework.SavePlayer(xPlayer, cb)
	if xPlayer.characterId ~= 0 and xPlayer['identity'] ~= nil then
		Framework.SyncPosition()

		parameters = {
			xPlayer.group,
			xPlayer.coins,
			xPlayer.identifier
		}
		parameters2 = {
			json.encode(xPlayer['identity'].getIdentity()),
			json.encode(xPlayer['skin'].getSkin()),
			json.encode(xPlayer['accounts'].getAccounts(true)),
			json.encode(xPlayer['jobs'].getJobs()),
			json.encode(xPlayer['inventory'].getInventory(true)),
			json.encode(xPlayer['loadout'].getLoadout(true)),
			json.encode(xPlayer['position'].getPosition()),
			xPlayer.characterId
		}
		MySQL.prepare("UPDATE `users` SET `group` = ?, `coins` = ? WHERE `identifier` = ?", parameters)
		MySQL.prepare("UPDATE `characters` SET `identity` = ?, `skin` = ?, `accounts` = ?, `jobs` = ?, `inventory` = ?, `loadout` = ?, `position` = ? WHERE `characterId` = ?", parameters2, function(affectedRows)
			if affectedRows == 1 then
				print(('[^2INFO^7] Sauvegarde du Joueur ^5"%s^7"'):format(xPlayer.name))
			end
			if cb then cb() end
		end)
	end
end

function Framework.SavePlayers(cb)
	Framework.SyncPosition()
	local xPlayers = Framework.GetExtendedPlayers()
	local count = #xPlayers
	if count > 0 then
		local parameters, parameters2 = {}, {}
		local time = os.time()
		for i=1, count do
			local xPlayer = xPlayers[i]
			if xPlayer.characterId ~= 0 and xPlayer['identity'] ~= nil then
				parameters[#parameters+1] = {
					xPlayer.group,
					xPlayer.coins,
					xPlayer.identifier
				}
				parameters2[#parameters2+1] = {
					json.encode(xPlayer['identity'].getIdentity()),
					json.encode(xPlayer['skin'].getSkin()),
					json.encode(xPlayer['accounts'].getAccounts(true)),
					json.encode(xPlayer['jobs'].getJobs()),
					json.encode(xPlayer['inventory'].getInventory(true)),
					json.encode(xPlayer['loadout'].getLoadout(true)),
					json.encode(xPlayer['position'].getPosition()),
					xPlayer.characterId
				}
			end
		end
		if next(parameters) and next(parameters2) then
			MySQL.prepare("UPDATE `users` SET `group` = ?, `coins` = ? WHERE `identifier` = ?", parameters)
			MySQL.prepare("UPDATE `characters` SET `identity` = ?, `skin` = ?, `accounts` = ?, `jobs` = ?, `inventory` = ?, `loadout` = ?, `position` = ? WHERE `characterId` = ?", parameters2, function(results)
				if results then
					if type(cb) == 'function' then cb() else print(('[^2INFO^7] Sauvegarde de %s %s'):format(count, count > 1 and 'joueurs' or 'joueur')) end
				end
			end)
		end
	end
end

function Framework.GetPlayers()
	local sources = {}

	for k,v in pairs(Framework.Players) do
		sources[#sources + 1] = k
	end

	return sources
end

function Framework.GetExtendedPlayers()
	local xPlayers = {}
	for k, v in pairs(Framework.Players) do
		xPlayers[#xPlayers + 1] = v
	end
	return xPlayers
end

function Framework.GetPlayerFromId(source)
	return Framework.Players[tonumber(source)]
end

function Framework.GetPlayerFromLicense(license)
	for k,v in pairs(Framework.Players) do
		if v.license == license then
			return v
		end
	end
end

function Framework.GetPlayerFromIdentifier(identifier)
	for k,v in pairs(Framework.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

function Framework.GetPlayerFromCharacterId(characterId)
	for k,v in pairs(Framework.Players) do
		if tonumber(v.characterId) == tonumber(characterId) then
			return v
		end
	end
end

function Framework.GetIdentifier(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			local identifier = string.gsub(v, 'license:', '')
			return identifier
		end
	end
end

function Framework.IsPlayerAdmin(playerId)
	if (IsPlayerAceAllowed(playerId, 'command') or GetConvar('sv_lan', '') == 'true') and true or false then
		return true
	end

	local xPlayer = Framework.GetPlayerFromId(playerId)

	if xPlayer then
		if Framework.HasRole(xPlayer.group) then
			return true
		end
	end

	return false
end

function Framework.HasRole(group)
	for k,v in pairs(Config.Group) do
		if v == group then
			return true
		end
	end

	return false
end

Framework.vehicleTypesByModel = {}

RegisterServerEvent('framework:vehicletype')
AddEventHandler('framework:vehicletype', function(model, vehicleType)
	Framework.vehicleTypesByModel[model] = vehicleType
end)

function Framework.GetVehicleType(model, player, cb)
	model = type(model) == 'string' and joaat(model) or model

	if Framework.vehicleTypesByModel[model] then
		return cb(Framework.vehicleTypesByModel[model])
	end

	TriggerClientEvent('framework:getvehicletype', player, model)
	Wait(1000)
	cb(Framework.vehicleTypesByModel[model])
end