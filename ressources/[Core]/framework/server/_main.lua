local newPlayer = 'INSERT INTO `users` SET `group` = ?, `name` = ?, `identifier` = ?'
local loadPlayerArgs = 'SELECT `group`, `coins`'

loadPlayerArgs = loadPlayerArgs..' FROM `users` WHERE identifier = ?'

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	local playerId = source
	local identifier = Framework.GetIdentifier(playerId)
	
	if identifier then
		if Framework.GetPlayerFromIdentifier(identifier) then
			print("^1 ERREUR FRAMEWORK: IDENTIFIER EXISTANT^0", Framework.GetPlayerFromIdentifier(identifier))
			deferrals.done(('There was an error loading your character!\nError code: identifier-active\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same account.\n\nYour identifier: %s'):format(identifier))
		else
			deferrals.done()
		end
	else
		print("^1 ERREUR FRAMEWORK: IDENTIFIER INVALIDE ", identifier)
		deferrals.done('There was an error loading your character!\nError code: identifier-missing\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
	end
end)

RegisterNetEvent('framework:onPlayerJoined')
AddEventHandler('framework:onPlayerJoined', function()
	local source = source
	while not next(Framework.JobsList) do Wait(50) end
	while not next(Framework.Jobs2List) do Wait(50) end

	if not Framework.Players[source] then
		onPlayerJoined(source)
	end
end)

function onPlayerJoined(playerId)
	local identifier = Framework.GetIdentifier(playerId)
	Wait(1)
	if identifier then
		if Framework.GetPlayerFromIdentifier(identifier) then
			DropPlayer(playerId, ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
		else
			local result = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', { identifier })
			if result then
				loadPlayer(identifier, playerId, false)
			else
				createPlayer(identifier, playerId)
			end
		end
	else
		DropPlayer(playerId, 'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
	end
end

function createPlayer(identifier, playerId)
	if Framework.IsPlayerAdmin(playerId) then
		defaultGroup = "admin"
	else
		defaultGroup = "user"
	end

	MySQL.prepare(newPlayer, { defaultGroup, GetPlayerName(playerId), identifier }, function()
		loadPlayer(identifier, playerId, true)
	end)
end

function loadPlayer(identifier, playerId, isNew)
	local userData = {
		uniqueId = 0,
		playerName = GetPlayerName(playerId),
		coins = 0
	}

	local result = MySQL.prepare.await(loadPlayerArgs, { identifier })

	-- Unique ID

	if result.uniqueId then
		userData.uniqueId = result.uniqueId
	end

	-- Group
	if result.group then
		userData.group = result.group
	else
		userData.group = 'user'
	end

	-- Coins
	if result.coins then
		userData.coins = result.coins
	end

	local xPlayer = CreateExtendedPlayer(playerId, userData.uniqueId, identifier, userData.playerName, userData.group, userData.coins)
	Framework.Players[playerId] = xPlayer

	TriggerEvent("framework:playerLoaded", playerId, xPlayer, isNew)

	xPlayer.triggerEvent('framework:playerLoaded', {
		identifier = xPlayer.getIdentifier(),
		coins = xPlayer.getCoins(),
        group = xPlayer.getGroup()
	}, isNew)

	xPlayer.triggerEvent('framework:registerSuggestions', Framework.RegisteredCommands)
	print(('[^2INFO^0] Le joueur ^5"%s" ^0c\'est connecté sur %s ! ID: ^5%s^7'):format(xPlayer.getName(), Config.ServerName3, playerId))
end

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source, character)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src);

	local userData = {
		identity = {},
		skin = {},
		accounts = {},
		jobs = { ['job'] = {}, ['job2'] = {} },
		inventory = {},
		loadout = {},
		position = {},
		weight = 0
	}

	local foundAccounts, foundItems = {}, {}

	local result = MySQL.prepare.await('SELECT `identity`, `skin`, `accounts`, `jobs`, `inventory`, `loadout`, `position` FROM `characters` WHERE characterId = ?', { character })

	-- IDENTITY --

	if result.identity and result.identity ~= '' then
		local identity = json.decode(result.identity)

		userData.identity = identity
		userData.fullName = userData.identity.firstname..' '..userData.identity.lastname
	end

	xPlayer['identity'] = CreateExtendedIdentity(src, character, userData.identity)
	Framework.Players[src]['identity'] = xPlayer['identity']

	-- SKIN --

	if result.skin and result.skin ~= '' then
		local skin = json.decode(result.skin)

		userData.skin = skin
	end

	xPlayer['skin'] = CreateExtendedSkin(src, character, userData.skin)
	Framework.Players[src]['skin'] = xPlayer['skin']

	-- ACCOUNTS --
	if result.accounts and result.accounts ~= '' then
		local accounts = json.decode(result.accounts)

		for account,money in pairs(accounts) do
			foundAccounts[account] = money
		end
	end

	for account,label in pairs(Config.Accounts) do
		userData.accounts[account] = {}
		userData.accounts[account].money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0

		table.insert(userData.accounts, {
			name = account,
			money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
			label = label
		})
	end

	xPlayer['accounts'] = CreateExtendedAccounts(src, character, userData.accounts)
	Framework.Players[src]['accounts'] = xPlayer['accounts']

	-- JOBS --

	local jobObject, gradeObject = Framework.JobsList['unemployed'], Framework.JobsList['unemployed'].grades['0']
	local job2Object, grade2Object = Framework.Jobs2List['unemployed2'], Framework.Jobs2List['unemployed2'].grades['0']

	if result.jobs and result.jobs ~= '' then
		local jobs = json.decode(result.jobs)

		for k,v in pairs(jobs) do
			if k == 'job' then
				if Framework.JOBS:DoesJobExist(v.name, v.grade) then
					jobObject, gradeObject = Framework.JobsList[v.name], Framework.JobsList[v.name].grades[tostring(v.grade)]
				else
					print(('[^3WARNING^7] Job Invalide pour %s [job: %s, grade: %s]'):format(xPlayer.identifier, v.name, v.grade))
					jobObject, gradeObject = Framework.JobsList['unemployed'], Framework.JobsList['unemployed'].grades['0']
				end
			elseif k == 'job2' then
				if Framework.JOBS2:DoesJob2Exist(v.name, v.grade) then
					job2Object, grade2Object = Framework.Jobs2List[v.name], Framework.Jobs2List[v.name].grades[tostring(v.grade)]
				else
					print(('[^3WARNING^7] Job2 Invalide pour %s [job2: %s, grade2: %s]'):format(xPlayer.identifier, v.name, v.grade))
					job2Object, grade2Object = Framework.Jobs2List['unemployed2'], Framework.Jobs2List['unemployed2'].grades['0']
				end
			end
		end
	end

	userData.jobs['job'].id = jobObject.id
	userData.jobs['job'].name = jobObject.name
	userData.jobs['job'].label = jobObject.label

	userData.jobs['job'].grade = gradeObject.grade
	userData.jobs['job'].grade_name = gradeObject.name
	userData.jobs['job'].grade_label = gradeObject.label

	userData.jobs['job2'].id = job2Object.id
	userData.jobs['job2'].name = job2Object.name
	userData.jobs['job2'].label = job2Object.label

	userData.jobs['job2'].grade = grade2Object.grade
	userData.jobs['job2'].grade_name = grade2Object.name
	userData.jobs['job2'].grade_label = grade2Object.label

	xPlayer['jobs'] = CreateExtendedJobs(src, character, userData.jobs)
	Framework.Players[src]['jobs'] = xPlayer['jobs']

	-- INVENTORY --
	if result.inventory and result.inventory ~= '' then
		local inventory = json.decode(result.inventory)

		for name,count in pairs(inventory) do
			local item = Framework.ITEMS.List[name]

			if item then
				foundItems[name] = count
			else
				print(("[^3WARNING^7] L'item '%s' est invalide pour '%s'"):format(name, xPlayer.identifier))
			end
		end
	end

	for name,item in pairs(Framework.ITEMS.List) do
		local count = foundItems[name] or 0
		if count > 0 then userData.weight = userData.weight + (item.weight * count) end

		table.insert(userData.inventory, {
			name = name,
			label = item.label,
			weight = item.weight,
			usable = Framework.ITEMS.UsableItemsCallbacks[name] ~= nil,
			canRemove = item.canRemove,
			count = count
		})
	end

	table.sort(userData.inventory, function(a, b)
		return a.label < b.label
	end)

	xPlayer['inventory'] = CreateExtendedInventory(src, character, userData.inventory, userData.weight)
	Framework.Players[src]['inventory'] = xPlayer['inventory']

	-- LOADOUT --
	if result.loadout and result.loadout ~= '' then
		local loadout = json.decode(result.loadout)
		
		for name,weapon in pairs(loadout) do
			local label = Framework.GetWeaponLabel(name)

			if label then
				if not weapon.components then weapon.components = {} end
				if not weapon.tintIndex then weapon.tintIndex = 0 end

				table.insert(userData.loadout, {
					name = name,
					ammo = weapon.ammo,
					label = label,
					components = weapon.components,
					tintIndex = weapon.tintIndex
				})
			end
		end
	end

	xPlayer['loadout'] = CreateExtendedLoadout(src, character, userData.loadout)
	Framework.Players[src]['loadout'] = xPlayer['loadout']

	-- POSITION --
	if result.position and result.position ~= '' then
		userData.position = json.decode(result.position)
	else
		userData.position = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8}
	end

	xPlayer['position'] = CreateExtendedPosition(src, character, userData.position)
	Framework.Players[src]['position'] = xPlayer['position']

	xPlayer.triggerEvent('framework:restoreCharacter', {
		characterId = xPlayer.characterId,
		identity    = xPlayer['identity'].getIdentity(),
		skin        = xPlayer['skin'].getSkin(),
		accounts    = xPlayer['accounts'].getAccounts(),
		jobs        = xPlayer['jobs'].getJobs(),
		inventory   = xPlayer['inventory'].getInventory(),
		loadout     = xPlayer['loadout'].getLoadout(),
		position    = xPlayer['position'].getPosition(),
		maxWeight   = xPlayer['inventory'].getMaxWeight(),
	})
end)

AddEventHandler('chatMessage', function(playerId, author, message)
	local xPlayer = Framework.GetPlayerFromId(playerId)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
		xPlayer.showNotification("Commande '"..commandName.."' invalide !")
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = Framework.GetPlayerFromId(playerId)
	local unloadPlayer = false;

	print("^1 Le joueur ID "..playerId.." s'est déconnecter, raison: "..reason.."^0")
	if xPlayer then
		TriggerEvent('framework:playerDropped', playerId, reason)

		Framework.SavePlayer(xPlayer, function()
			unloadPlayer = true
			Framework.Players[playerId] = nil
		end)
	else
		Framework.Players[playerId] = nil
		unloadPlayer = true
	end

	TriggerClientEvent("framework:onPlayerLogout", playerId)

	Wait(10000)
	if not unloadPlayer then 
		Framework.Players[playerId] = nil 
	end
end)

Framework.RegisterServerCallback('framework:isUserAdmin', function(source, cb)
	cb(Framework.IsPlayerAdmin(source))
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
			Framework.SavePlayers()
		end)
	end
end)