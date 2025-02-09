
RegisterServerEvent('billing:sendBill')
AddEventHandler('billing:sendBill', function(target, sharedAccountName, label, amount)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)
	local xTarget = Framework.GetPlayerFromId(target)

	if label == nil then label = "Facture" end
	amount = Framework.Math.Round(amount)

	if amount > 0 then
		if xTarget ~= nil then
			MySQL.Async.execute('INSERT INTO character_billings (characterId, sender, target_type, target, label, amount) VALUES (@characterId, @sender, @target_type, @target, @label, @amount)', {
				['@characterId'] = xTarget.characterId,
				['@sender'] = xPlayer.characterId,
				['@target_type'] = 'society',
				['@target'] = sharedAccountName,
				['@label'] = label,
				['@amount'] = amount
			}, function(rowsChanged)
				xTarget.showNotification("Vous avez reçu une facture !")
				TriggerClientEvent('billing:newBill', target)
			end)
		end
	end
end)

Framework.RegisterServerCallback("billing:getBills", function(source, cb)
	local xPlayer = Framework.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM character_billings WHERE characterId = @characterId', {
		['@characterId'] = xPlayer.characterId
	}, function(result)
		local bills = {}

		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				characterId = result[i].characterId,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

Framework.RegisterServerCallback("billing:getTargetBills", function(source, cb, target)
	local xPlayer = Framework.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM character_billings WHERE characterId = @characterId', {
		['@characterId'] = xPlayer.characterId
	}, function(result)
		local bills = {}

		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				characterId = result[i].characterId,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

Framework.RegisterServerCallback("billing:payBill", function(source, cb, id)
	local xPlayer = Framework.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM character_billings WHERE id = @id', {
		['@id'] = id
	}, function(result)
		local sender = result[1].sender
		local targetType = result[1].target_type
		local target = result[1].target
		local amount = result[1].amount
		local xTarget = Framework.GetPlayerFromCharacterId(sender)

		if targetType == 'player' then
			if xTarget ~= nil then
				if xPlayer['accounts'].getAccount('bank').money >= amount then
					MySQL.Async.execute('DELETE from character_billings WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer['accounts'].removeAccountMoney('bank', amount)
						xTarget['accounts'].addAccountMoney('bank', amount)
						xPlayer.showNotification("Vous avez payer une facture de ~g~"..Framework.Math.GroupDigits(amount).."$ ~s~!")
						if xTarget ~= nil then xTarget.showNotification("Vous avez reçu un paiement de ~g~"..Framework.Math.GroupDigits(amount).."$ ~s~!") end
						cb()
					end)
				else
					xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
					if xTarget ~= nil then xTarget.showNotification("~r~La personne n'a pas asser d'argent !") end
					cb()
				end
			else
				xPlayer.showNotification("~r~La personne n'est plus en ligne !")
				cb()
			end
		else
			if xPlayer['accounts'].getAccount('bank').money >= amount then
				MySQL.Async.execute('DELETE from character_billings WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					xPlayer['accounts'].removeAccountMoney('bank', amount)
					TriggerEvent('bossManagement:depositMoneybyOther', target, amount)
					xPlayer.showNotification("Vous avez payer une facture de ~g~"..Framework.Math.GroupDigits(amount).."$ ~s~!")
					if xTarget ~= nil then xTarget.showNotification("Vous avez reçu un paiement de ~g~"..Framework.Math.GroupDigits(amount).."$ ~s~!") end
					cb()
				end)
			else
				xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
				if xTarget ~= nil then xTarget.showNotification("~r~La personne n'a pas asser d'argent !") end
				cb()
			end
		end
	end)
end)