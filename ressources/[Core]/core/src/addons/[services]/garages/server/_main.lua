
Garages = {}

MySQL.ready(function()
	MySQL.Async.execute('UPDATE character_vehicles SET state = true WHERE state = false', {}, function() end)
end)

Framework.RegisterServerCallback('garages:getOwneds', function(src, cb, typeG)
    local xPlayer = Framework.GetPlayerFromId(src)

    if typeG == 'car' then
        Garages.ownedCars = {}

        MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND type = @type OR characterId = @characterId AND type = @type2', {
            ['@characterId'] = xPlayer.characterId,
            ['@type'] = 'car',
            ['@type2'] = 'boutique'
        }, function(data)
            for k, v in pairs(data) do
                if xPlayer.characterId == v.characterId then
                    local vehicle = json.decode(v.vehicle)
        
                    table.insert(Garages.ownedCars, {
                        characterId = xPlayer.characterId,
                        vehicle = vehicle, 
                        state = v.state, 
                        label = v.label or "Ma Voiture",
                        plate = v.plate, 
                        type = v.type,
                        assurance = v.assurance
                    })

                end
            end

            cb(Garages.ownedCars)
        end)
    elseif typeG == 'boat' then
        Garages.ownedBoats = {}

        MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND type = @type', {
            ['@characterId'] = xPlayer.characterId,
            ['@type'] = 'boat'
        }, function(data)
            for k, v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
    
                table.insert(Garages.ownedBoats, {
                    characterId = xPlayer.characterId,
                    vehicle = vehicle, 
                    state = v.state, 
                    label = v.label,
                    plate = v.plate, 
                    type = v.type,
                    assurance = v.assurance
                })
            end

            cb(Garages.ownedBoats)
        end)
    elseif typeG == 'aircraft' then
        Garages.ownedAircrafts = {}

        MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND type = @type', {
            ['@characterId'] = xPlayer.characterId,
            ['@type'] = 'aircraft'
        }, function(data)
            for k, v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
    
                table.insert(Garages.ownedAircrafts, {
                    characterId = xPlayer.characterId,
                    vehicle = vehicle, 
                    state = v.state, 
                    label = v.label,
                    plate = v.plate, 
                    type = v.type,
                    assurance = v.assurance
                })
            end

            cb(Garages.ownedAircrafts)
        end)
    end
end)

RegisterServerEvent('garages:renameVehicle')
AddEventHandler('garages:renameVehicle', function(vehicle, name)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(source);

    MySQL.query("UPDATE character_vehicles SET label = @label WHERE characterId = @characterId AND plate = @plate", {
        ['@characterId'] = xPlayer.characterId,
        ['@plate'] = vehicle.plate,
        ['@label'] = name or 'Ma Voiture'
    })

    for k,v in pairs(Garages.ownedCars) do
        if v.plate == vehicle.plate then
            v.label = name
        end
    end
end)

RegisterServerEvent('garages:storeVehicle')
AddEventHandler('garages:storeVehicle', function(vehicleProps)
    local vehiclemodel = vehicleProps.model
    local src = source
	local xPlayer = Framework.GetPlayerFromId(src)
	
	MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND @plate = plate', {
		['@characterId'] = xPlayer.characterId,
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)

			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE character_vehicles SET vehicle = @vehicle, state = @state WHERE characterId = @characterId AND plate = @plate', {
					['@characterId'] = xPlayer.characterId,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate,
                    ['@state'] = true
				})
            else
                print("[GARAGES] vehicle model invalide")
			end
		end
	end)
end)

RegisterServerEvent('garages:updateState')
AddEventHandler('garages:updateState', function(vehicle, state)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(source);

    MySQL.query("UPDATE character_vehicles SET state = @state WHERE characterId = @characterId AND plate = @plate", {
        ['@characterId'] = xPlayer.characterId,
        ['@plate'] = vehicle.plate,
        ['@state'] = state
    })
end)
