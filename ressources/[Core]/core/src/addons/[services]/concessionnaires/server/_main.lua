
Framework.RegisterServerCallback("Concess:isPlateTaken", function(src, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

Framework.RegisterServerCallback("Concess:haveMoney", function(src, cb, info)
    local xPlayer = Framework.GetPlayerFromId(src);
    local price, method = info.price, info.method;
    if xPlayer['accounts'].accounts[method].money >= tonumber(price) then 
        xPlayer['accounts'].removeAccountMoney(method, tonumber(price)) 
        xPlayer.showNotification("Vous avez payé ~g~"..price.."$~s~.")
        cb(true) 
    else 
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
        cb(false)
    end
end)

RegisterNetEvent('concess:buyVehicle')
AddEventHandler('concess:buyVehicle', function(type, vehicleProps)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

	MySQL.Async.execute('INSERT INTO character_vehicles (characterId, plate, vehicle, type, state) VALUES (@characterId, @plate, @vehicle, @type, @state)', {
		['@characterId'] = xPlayer.characterId,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type'] = type,
		['@state'] = false
	}, function()
	end)
end)