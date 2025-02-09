
RegisterServerEvent("CayoEmsJob:revive")
AddEventHandler("CayoEmsJob:revive", function(target)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer['jobs'].job.name ~= 'cayoems' then
		TriggerEvent('BanSql:ICheatServer', src)

		return
	end

	local srcPed = GetPlayerPed(src)
	local targetPed = GetPlayerPed(target)

	if #(GetEntityCoords(srcPed) - GetEntityCoords(targetPed)) < 8.0 and GetEntityHealth(targetPed) <= 0.0 then
		xPlayer['inventory'].removeInventoryItem('defibrillateur', 1)
		xPlayer['accounts'].addAccountMoney('money', Config['job_cayoems'].ReviveReward)

		TriggerClientEvent("CayoEmsJob:revive", target)
		xPlayer.showNotification("Vous avez ~g~réanimer ~s~la personne !")
	end
end)

RegisterServerEvent("CayoEmsJob:Heal")
AddEventHandler("CayoEmsJob:Heal", function(ped, target, type)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)
	local haveItem = false

	if type > 0 and type < 3 then
		if xPlayer['inventory'].getInventoryItem('bandage') ~= nil then
			if xPlayer['inventory'].getInventoryItem('bandage').count > 0 then
				haveItem = true
				TriggerClientEvent("CayoEmsJob:Heal", target, ped, type)
			end
		else
			haveItem = false
			print("^1Erreur CayoEmsJob: Item Invalide bandage^0")
		end
	elseif type > 0 and type == 3 then
		if xPlayer['inventory'].getInventoryItem('medikit') ~= nil then
			if xPlayer['inventory'].getInventoryItem('medikit').count > 0 then
				haveItem = true
				TriggerClientEvent("CayoEmsJob:Heal", target, ped, type)
			end
		else
			haveItem = false
			print("^1Erreur CayoEmsJob: Item Invalide medikit^0")
		end
	end

	if not haveItem then
		xPlayer.showNotification("~r~Vous n'avez pas les items requis !")
	end
end)

Framework.RegisterServerCallback("CayoEmsJob:getItemAmount", function(src, cb, item)
	local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer['inventory'].getInventoryItem(item) ~= nil then
		cb(xPlayer['inventory'].getInventoryItem(item).count)
	else
		print("^1Erreur CayoEmsJob: Item Invalide "..item.."^0")
		cb(0)
	end
end)