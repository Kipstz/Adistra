
RegisterServerEvent("AmbulanceJob:revive")
AddEventHandler("AmbulanceJob:revive", function(target)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer['jobs'].job.name ~= 'ambulance' then
		TriggerEvent('BanSql:ICheatServer', src)

		return
	end

	local srcPed = GetPlayerPed(src)
	local targetPed = GetPlayerPed(target)

	if #(GetEntityCoords(srcPed) - GetEntityCoords(targetPed)) < 8.0 and GetEntityHealth(targetPed) <= 0.0 then
		xPlayer['inventory'].removeInventoryItem('defibrillateur', 1)
		xPlayer['accounts'].addAccountMoney('money', Config['job_ambulance'].ReviveReward)

		TriggerClientEvent("AmbulanceJob:revive", target)
		xPlayer.showNotification("Vous avez ~g~réanimer ~s~la personne !")
	end
	comaCalls[src] = nil
end)

RegisterServerEvent("AmbulanceJob:Heal")
AddEventHandler("AmbulanceJob:Heal", function(ped, target, type)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)
	local haveItem = false

	if type > 0 and type < 3 then
		if xPlayer['inventory'].getInventoryItem('bandage') ~= nil then
			if xPlayer['inventory'].getInventoryItem('bandage').count > 0 then
				haveItem = true
				TriggerClientEvent("AmbulanceJob:Heal", target, ped, type)
			end
		else
			haveItem = false
			print("^1Erreur AMBULANCEJOB: Item Invalide bandage^0")
		end
	elseif type > 0 and type == 3 then
		if xPlayer['inventory'].getInventoryItem('medikit') ~= nil then
			if xPlayer['inventory'].getInventoryItem('medikit').count > 0 then
				haveItem = true
				TriggerClientEvent("AmbulanceJob:Heal", target, ped, type)
			end
		else
			haveItem = false
			print("^1Erreur AMBULANCEJOB: Item Invalide medikit^0")
		end
	end

	if not haveItem then
		xPlayer.showNotification("~r~Vous n'avez pas les items requis !")
	end
end)


Framework.RegisterServerCallback("AmbulanceJob:getDeathStatus", function(src, cb)
	local xPlayer = Framework.GetPlayerFromId(src)

	local isDead = MySQL.scalar.await('SELECT isDead FROM characters WHERE characterId = ?', {xPlayer.characterId})
	cb(isDead)
end)

RegisterServerEvent("AmbulanceJob:setDeathStatus")
AddEventHandler("AmbulanceJob:setDeathStatus", function(isDead)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

	MySQL.update.await('UPDATE characters SET isDead = ? WHERE characterId = ?', {isDead, xPlayer.characterId})
end)

Framework.RegisterServerCallback("AmbulanceJob:getItemAmount", function(src, cb, item)
	local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer['inventory'].getInventoryItem(item) ~= nil then
		cb(xPlayer['inventory'].getInventoryItem(item).count)
	else
		print("^1Erreur AMBULANCEJOB: Item Invalide "..item.."^0")
		cb(0)
	end
end)

Framework.RegisterCommand('rea', {'mod', 'cm', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent("AmbulanceJob:revive")
	comaCalls[args.playerId] = nil
end, true, {help = "Réanimer un Joueur", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

Framework.RegisterCommand('reviveall', {'superadmin', 'owner'}, function(xPlayer, args, showError)
	TriggerClientEvent("AmbulanceJob:revive", -1)
	comaCalls = nil
	comaCalls = {}
end, true, {help = "Réanimer tout les joueurs", validate = true
})

Framework.ITEMS:RegisterUsableItem('medikit', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)

	xPlayer['inventory'].removeInventoryItem('medikit', 1)

	TriggerClientEvent("AmbulanceJob:Heal", xPlayer.source, nil, 'big')
    xPlayer.showNotification("Vous avez utilisé ~b~1x ~g~MediKit")
end)

Framework.ITEMS:RegisterUsableItem('bandage', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)

	xPlayer['inventory'].removeInventoryItem('bandage', 1)

	TriggerClientEvent("AmbulanceJob:Heal", xPlayer.source, nil, 'small')

    xPlayer.showNotification("Vous avez utilisé ~b~1x ~g~Bandage")
end)