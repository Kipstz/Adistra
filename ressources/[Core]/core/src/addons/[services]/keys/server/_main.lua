Keys = {}

MySQL.ready(function()
	MySQL.Async.execute('DELETE FROM vehicle_keys WHERE temporary = 1')
end)

Framework.RegisterServerCallback('keys:getOwneds', function(src, cb)
    local xPlayer = Framework.GetPlayerFromId(src)

    Keys.owned = {}

    MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId', {
        ['@characterId'] = xPlayer.characterId
    }, function(data)
        for k, v in pairs(data) do
            if xPlayer.characterId == v.characterId then
                local vehicle = json.decode(v.vehicle)
    
                table.insert(Keys.owned, {
                    characterId = xPlayer.characterId,
                    vehicle = vehicle, 
                    label = v.label,
                    plate = v.plate, 
                })

            end
        end

        cb(Keys.owned)
    end)
end)


Framework.RegisterServerCallback('keys:getMyKeys', function(src, cb)
    local xPlayer = Framework.GetPlayerFromId(src)

    Keys.myKeys = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE characterId = @characterId', {
        ['@characterId'] = xPlayer.characterId,
    }, function(data)
        if not next(data) then
            cb(Keys.myKeys)
        else
            for k, v in pairs(data) do
                if v.temporary == 1 then
                    temporary = "Temporaire";
                elseif v.temporary == 0 then
                    temporary = nil;
                end

				if Garages:GetLabelByPlate(v.plate) ~= nil then
					table.insert(Keys.myKeys, {
						characterId = xPlayer.characterId,
						plate = v.plate,
						vehicleLabel = Garages:GetLabelByPlate(v.plate),
						temporary = temporary
					})
				else
					table.insert(Keys.myKeys, {
						characterId = xPlayer.characterId,
						plate = v.plate,
						vehicleLabel = "Véhicule Temporaire",
						temporary = temporary
					})
				end
            end

        end

        cb(Keys.myKeys)
    end)
end)

RegisterNetEvent('keys:buy_key')
AddEventHandler('keys:buy_key', function(vehicle)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local myMoney = tonumber(xPlayer['accounts'].getAccount('bank').money);
    local price = tonumber(Config['keys'].price);

    MySQL.Async.fetchScalar('SELECT COUNT(1) FROM vehicle_keys WHERE plate = ? AND characterId = ?', { vehicle.plate, xPlayer.characterId}, function(count)
        if count < 1 then
            if myMoney < price then
                xPlayer.showNotification("~r~Vous n'avez pas asser d'argent en banque ! Il vous faut "..price.."$.")
            else
                MySQL.insert.await('INSERT INTO `vehicle_keys` (characterId, plate, temporary) VALUES (?, ?, ?)', {
                    xPlayer.characterId, vehicle.plate, 0
                })
				xPlayer['accounts'].removeAccountMoney('bank', price)
                xPlayer.showNotification("~g~Vous avez reçu une nouvelle paire de clés pour la somme de "..price.."$ !")
            end
        elseif count > 0 then
            xPlayer.showNotification("~r~Vous avez déjà les clés de ce véhicule !")
            return
        end
    end)
end)

RegisterNetEvent('keys:donner')
AddEventHandler('keys:donner', function(target, plate, vehicleProps)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local xTarget = Framework.GetPlayerFromId(target);

    MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND @plate = plate', {
		['@characterId'] = xPlayer.characterId,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			if result[1].type ~= 'boutique' then
				local vehicle = json.decode(result[1].vehicle)

				if vehicle.model == vehicleProps.model and vehicle.plate == plate then
					MySQL.Async.execute('UPDATE character_vehicles SET characterId = @target WHERE characterId = @characterId AND plate = @plate', {
						['@characterId'] = xPlayer.characterId,
						['@target'] = xTarget.characterId,
						['@plate'] = plate
					}, function()
						MySQL.Async.execute('DELETE FROM vehicle_keys WHERE characterId = @characterId AND plate = @plate', {
							['@characterId'] = xPlayer.characterId,
							['@plate'] = plate
						}, function()
							MySQL.Async.execute('INSERT INTO vehicle_keys (characterId, plate, temporary) VALUES (@characterId, @plate, @temporary)', {
								['@characterId'] = xTarget.characterId,
								['@plate'] = plate,
								['@temporary'] = 0
							}, function()
								xPlayer.showNotification("Vous avez donné votre clé, vous ne les avez plus !")
								xTarget.showNotification("Vous avez reçu une nouvelle clé")
							end)
						end)
					end)
				end
			else
				xPlayer.showNotification("~r~Vous ne pouvez pas donner ce véhicule !")
			end
		else
			xPlayer.showNotification("~r~Le véhicule le plus proche ne vous appartient pas !")
		end
	end)
end)

RegisterNetEvent('keys:preter')
AddEventHandler('keys:preter', function(target, vehicle)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local xTarget = Framework.GetPlayerFromId(target);

    MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND @plate = plate', {
		['@characterId'] = xPlayer.characterId,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			if result[1].type ~= 'boutique' then
				local vehicle = json.decode(result[1].vehicle)

				if vehicle.model == vehicleProps.model and vehicle.plate == plate then
					MySQL.Async.execute('UPDATE character_vehicles SET characterId = @target WHERE characterId = @characterId AND plate = @plate', {
						['@characterId'] = xPlayer.characterId,
						['@target'] = xTarget.characterId,
						['@plate'] = plate
					}, function()
						MySQL.Async.execute('DELETE FROM vehicle_keys WHERE characterId = @characterId AND plate = @plate', {
							['@characterId'] = xPlayer.characterId,
							['@plate'] = plate
						}, function()
							MySQL.Async.execute('INSERT INTO vehicle_keys (characterId, plate, temporary) VALUES (@characterId, @plate, @temporary)', {
								['@characterId'] = xTarget.characterId,
								['@plate'] = plate,
								['@temporary'] = 1
							}, function()
								xPlayer.showNotification("Vous avez donné votre clé, vous ne les avez plus !")
								xTarget.showNotification("Vous avez reçu une nouvelle clé")
							end)
						end)
					end)
				end
			else
				xPlayer.showNotification("~r~Vous ne pouvez pas donner ce véhicule !")
			end
		else
			xPlayer.showNotification("~r~Le véhicule le plus proche ne vous appartient pas !")
		end
	end)
end)

RegisterServerEvent('keys:givekey')
AddEventHandler('keys:givekey', function(target, plate)
	local src = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = Framework.GetPlayerFromId(target)
	else
		xPlayer = Framework.GetPlayerFromId(src)
	end

	Wait(500)

	MySQL.Async.execute('INSERT INTO vehicle_keys (characterId, plate, temporary) VALUES (@characterId, @plate, @temporary)', {
		['@characterId'] = xPlayer.characterId,
		['@plate'] = plate,
		['@temporary'] = 1
	}, function()
		TriggerClientEvent('framework:showAdvancedNotification', xPlayer.source, 'AdistraRP', '~y~Clés', 'Vous avez recu un double de clés ', 'CHAR_ADISTRA', 7)
	end)
end)