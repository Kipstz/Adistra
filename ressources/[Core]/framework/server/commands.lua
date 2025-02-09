Framework.RegisterCommand('heading', { 'owner' }, function(xPlayer, args, showError)
    local plyPed = GetPlayerPed(args.playerId.source)
    local myHeading = GetEntityHeading(plyPed)
    print(("heading: %s)"):format(myHeading))
end, true, {help = "Obtenir les Coordonnées d'un joueur", validate = true, arguments = {
	{name = 'playerId', help = "ID du Joueur", type = 'player'}
}})

Framework.RegisterCommand('setcoords', {'owner' }, function(xPlayer, args, showError)
	xPlayer['position'].setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = "Se téléporter a des coordonnées", validate = true, arguments = {
	{name = 'x', help = "Coord. x", type = 'number'},
	{name = 'y', help = "Coord. y", type = 'number'},
	{name = 'z', help = "Coord. z", type = 'number'}
}})

Framework.RegisterCommand('setjob', { 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if Framework.JOBS:DoesJobExist(args.job, args.grade) then
		args.playerId['jobs'].setJob(args.job, args.grade)
		if xPlayer then
			print("Setjob par "..xPlayer.source)
		else
			exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été setjob \nJob: **%s** \nGrade: **%s**"):format(args.playerId.getName(), args.job, args.grade), player_id = args.playerId.source, channel = 'adminCommands'})
		end
	else
		showError("Job invalide !")
	end
end, true, {help = "Se set job", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'job', help = "Nom du job", type = 'string'},
	{name = 'grade', help = "Grade du Job", type = 'number'}
}})

Framework.RegisterCommand('setjob2', { 'gi', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if Framework.JOBS2:DoesJob2Exist(args.job2, args.grade2) then
		args.playerId['jobs'].setJob2(args.job2, args.grade2)
		if xPlayer then
			print("Setjob2 par "..xPlayer.source)
		else
			exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été setjob2 \nJob: **%s** \nGrade: **%s**"):format(args.playerId.getName(), args.job2, args.grade2), player_id = args.playerId.source, channel = 'adminCommands'})
		end
	else
		showError("Job invalide !")
	end
end, true, {help = "Se set job2", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'job2', help = "Nom du job", type = 'string'},
	{name = 'grade2', help = "Grade du Job", type = 'number'}
}})

Framework.RegisterCommand('car', { 'mod', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	-- xPlayer.triggerEvent('framework:spawnVehicle', args.car)
	local plyPed = GetPlayerPed(xPlayer.source)
	local plyCoords = GetEntityCoords(plyPed)
	local plyHeading = GetEntityHeading(plyPed)
	Framework.OneSync:SpawnVehicle(args.car, plyCoords, plyHeading, upgrades, function(veh, networkId)
		if networkId then
			local vehicle = NetworkGetEntityFromNetworkId(networkId)
			for _ = 1, 20 do
				Wait(1)
				SetPedIntoVehicle(plyPed, vehicle, -1)

				if GetVehiclePedIsIn(plyPed, false) == vehicle then
					break
				end
			end
			if GetVehiclePedIsIn(plyPed, false) ~= vehicle then
				showError('[^1ERROR^7] The player could not be seated in the vehicle')
			end
		end
	end)
	exports['Logs']:createLog({EmbedMessage = ("**%s** a /car **%s**"):format(xPlayer.getName(), args.car), player_id = xPlayer.source, channel = 'adminCommands'})
end, false, {help = "Faire apparaître un véhicule", validate = false, arguments = {
	{name = 'car', help = "Model du véhicule", type = 'any'}
}})

Framework.RegisterCommand('dv', { 'mod', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	-- local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
	-- if DoesEntityExist(PedVehicle) then
	-- 	DeleteEntity(PedVehicle)
	-- end
	-- local Vehicles = ESX.OneSync.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(xPlayer.source)), tonumber(args.radius) or 5.0)
	-- for i = 1, #Vehicles do
	-- 	local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
	-- 	if DoesEntityExist(Vehicle) then
	-- 		DeleteEntity(Vehicle)
	-- 	end
	-- end
	if not args.radius then args.radius = 4 end
	xPlayer.triggerEvent('framework:deleteVehicle', args.radius)
end, false, {help = "Supprimer le véhicule à proximité", validate = false, arguments = {
	{name = 'radius', help = "Optionnel, supprime les véhicules dans un rayon spécifié", type = 'any'}
}})

Framework.RegisterCommand('setmoney', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if args.playerId['accounts'].getAccount(args.account) then
		if not xPlayer then
			args.playerId['accounts'].setAccountMoney(args.account, args.amount)
			exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été setmoney \nCompte: **%s** \nSomme: **%s**"):format(args.playerId.getName(), args.account, args.amount), player_id = args.playerId.source, channel = 'adminCommands'})
		end
	else
		showError("Type de money Invalide")
	end
end, true, {help = "Set set de l'argent", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'account', help = "Compte (money, black_money, bank)", type = 'string'},
	{name = 'amount', help = "Montant", type = 'number'}
}})

Framework.RegisterCommand('givemoney', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if args.playerId['accounts'].getAccount(args.account) then
		if not xPlayer then
			args.playerId['accounts'].addAccountMoney(args.account, args.amount)
			exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été givemoney \nCompte: **%s** \nSomme: **%s**"):format(args.playerId.getName(), args.account, args.amount), player_id = args.playerId.source, channel = 'adminCommands'})
		else
			showError("Impossible")
		end
	else
		showError("Type de money Invalide")
	end
end, true, {help = "Se give de l'argent", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'account', help = "Compte (money, black_money, bank)", type = 'string'},
	{name = 'amount', help = "Montant", type = 'number'}
}})

Framework.RegisterCommand('setitem', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if not xPlayer then
		args.playerId['inventory'].setInventoryItem(args.item, args.count)
		exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été setitem \nItem: **%s** \nQuantité: **%s**"):format(args.playerId.getName(), args.item, args.count), player_id = args.playerId.source, channel = 'adminCommands'})
	end
end, true, {help = "Se set un item", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'item', help = "Nom de l'item", type = 'item'},
	{name = 'count', help = "Nombre d'items", type = 'number'}
}})

Framework.RegisterCommand('giveitem', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if not xPlayer then
		args.playerId['inventory'].addInventoryItem(args.item, args.count)
		exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été additem \nItem: **%s** \nQuantité: **%s**"):format(args.playerId.getName(), args.item, args.count), player_id = args.playerId.source, channel = 'adminCommands'})
	end
end, true, {help = "Se give un item", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'item', help = "Nom de l'item", type = 'item'},
	{name = 'count', help = "Nombre d'items", type = 'number'}
}})

Framework.RegisterCommand('removeitem', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if not xPlayer then
		args.playerId['inventory'].removeInventoryItem(args.item, args.count)
		exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été removeitem \nItem: **%s** \nQuantité: **%s**"):format(args.playerId.getName(), args.item, args.count), player_id = args.playerId.source, channel = 'adminCommands'})
	end
end, true, {help = "Se retirer un item", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'item', help = "Nom de l'item", type = 'item'},
	{name = 'count', help = "Nombre d'items", type = 'number'}
}})

Framework.RegisterCommand('giveweapon', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if args.playerId['loadout'].hasWeapon(args.weapon) then
		showError("Vous avez déjà cette arme !")
	else
		if not xPlayer then
			args.playerId['loadout'].addWeapon(args.weapon, args.ammo)
			exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été giveweapon \nArme: **%s** \nMunitions: **%s**"):format(args.playerId.getName(), args.weapon, args.ammo), player_id = args.playerId.source, channel = 'adminCommands'})
		end
	end
end, true, {help = "Se give une arme", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'weapon', help = "Nom de l'arme", type = 'weapon'},
	{name = 'ammo', help = "Nombre de Munitions", type = 'number'}
}})

Framework.RegisterCommand('removeweapon', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if args.playerId['loadout'].hasWeapon(args.weapon) then
		if not xPlayer then
			args.playerId['loadout'].removeWeapon(args.weapon)
			exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été removeweapon \nArme: **%s**"):format(args.playerId.getName(), args.weapon), player_id = args.playerId.source, channel = 'adminCommands'})
		end
	else
		showError("Vous n'avez pas cette arme !")
	end
end, true, {help = "Se retirer une arme", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'weapon', help = "Nom de l'arme", type = 'weapon'}
}})

Framework.RegisterCommand('giveweaponcomponent', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if args.playerId['loadout'].hasWeapon(args.weaponName) then
		local component = Framework.GetWeaponComponent(args.weaponName, args.componentName)

		if component then
			if args.playerId['loadout'].hasWeaponComponent(args.weaponName, args.componentName) then
				showError("Vous avez déjà cet accessoire !")
			else
				if not xPlayer then
					args.playerId['loadout'].addWeaponComponent(args.weaponName, args.componentName)
					exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été giveweaponcomponent \nArme: **%s** \nAccessoire: **%s**"):format(args.playerId.getName(), args.weaponName, args.componentName), player_id = args.playerId.source, channel = 'adminCommands'})
				end
			end
		else
			showError("Component Invalide !")
		end
	else
		showError("Vous n'avez pas cette arme !")
	end
end, true, {help = "Se give un accessoire d'arme", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'weaponName', help = "Nom de l'arme", type = 'weapon'},
	{name = 'componentName', help = "Nom de l'accessoire", type = 'string'}
}})

Framework.RegisterCommand({'clear', 'cls'}, { 'user', 'mod', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = "Clear le chat pour moi"})

Framework.RegisterCommand({'clearall', 'clsall'}, { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = "Clear le chat pour tous"})

Framework.RegisterCommand('clearinventory', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	local can = false;
	if not xPlayer then
		for k,v in ipairs(args.playerId['inventory'].inventory) do
			if v.count > 0 then
				can = true;
				args.playerId['inventory'].setInventoryItem(v.name, 0)
			end
		end
	end
	if can then
		exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été clearinventory"):format(args.playerId.getName()), player_id = args.playerId.source, channel = 'adminCommands'})
	end
end, true, {help = "Clear l'inventaire", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

Framework.RegisterCommand('clearloadout', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	local can = false;
	if not xPlayer then
		for i=#args.playerId['loadout'].loadout, 1, -1 do
			can = true;
			args.playerId['loadout'].removeWeapon(args.playerId['loadout'].loadout[i].name)
		end
	end
	if can then
		exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été clearloadout"):format(args.playerId.getName()), player_id = args.playerId.source, channel = 'adminCommands'})
	end
end, true, {help = "Clear les armes", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

Framework.RegisterCommand('setgroup', { 'owner' }, function(xPlayer, args, showError)
	if not args.playerId then args.playerId = xPlayer.source end
	if not xPlayer then
		args.playerId.setGroup(args.group)
		exports['Logs']:createLog({EmbedMessage = ("(CONSOLE) **%s** a été setgroup **%s**"):format(args.playerId.getName(), args.group), player_id = args.playerId.source, channel = 'adminCommands'})
	end
end, true, {help = "Se set Group", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'},
	{name = 'group', help = "Group", type = 'string'},
}})

Framework.RegisterCommand('save', { 'mod', 'admin', 'gi', 'gl','main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	Framework.SavePlayer(args.playerId)
	print("[^2Info^0] Joueur Sauvegardé !")
end, true, {help = "Sauvegarder mon Personnage", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

Framework.RegisterCommand('saveall', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
	Framework.SavePlayers()
end, true, {help = "Sauvegarder tous les joueurs"})

Framework.RegisterCommand('group', {'user', 'mod', 'admin', 'gi', 'gl','main-team', 'gamemaster', 'superadmin', 'owner'}, function(xPlayer, args, showError)
	print(xPlayer.getName()..", Vous êtes actuellement: ^5".. xPlayer.getGroup() .. "^0")
end, true)

Framework.RegisterCommand('tpm', {'mod', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	xPlayer.triggerEvent("framework:tpm")
end, true, {help = "Se téléporter sur le Marker", validate = true
})

Framework.RegisterCommand('goto', {'mod', 'admin', 'gi', 'gl','main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	local targetCoords = GetEntityCoords(GetPlayerPed(args.playerId.source))
	
	xPlayer['position'].setCoords(targetCoords)
end, true, {help = "Se téléporter sur un Joueur", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

local goback = {}

Framework.RegisterCommand('bring', {'mod', 'admin', 'gi', 'gl','main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
	
	if args.playerId['position'] then
		goback[args.playerId.source] = GetEntityCoords(GetPlayerPed(args.playerId.source))
	    args.playerId['position'].setCoords(playerCoords)
	end
end, true, {help = "Téléporter un Joueur a moi", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

Framework.RegisterCommand('goback', {'mod', 'admin', 'gi', 'gl','main-team', 'gamemaster', 'superadmin', 'owner' }, function(xPlayer, args, showError)
	if goback[args.playerId.source] then
	    args.playerId['position'].setCoords(goback[args.playerId.source])
	end
end, true, {help = "Faire retourner un joueur à sa position initiale", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})
--[[
Framework.RegisterCommand('setliveryveh', function(src, args)
    local plyPed = PlayerPedId()
    local inVeh = IsPedInAnyVehicle(plyPed)

    if inVeh then
        local veh = GetVehiclePedIsIn(plyPed)
        SetVehicleLivery(veh, tonumber(args[1]))
    end
end)]]
