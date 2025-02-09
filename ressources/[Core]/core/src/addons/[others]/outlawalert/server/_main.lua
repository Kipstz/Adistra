
RegisterServerEvent('outlawalert:alert')
AddEventHandler('outlawalert:alert', function(alertType, coords, sex, street1, street2)
	TriggerClientEvent('outlawalert:alert', -1, alertType, coords, sex, street1, street2)
end)

-- Framework.RegisterServerCallback('outlawalert:ownvehicle',function(source,cb, vehicleProps)
-- 	local src = source;
-- 	local isFound = false;
-- 	local xPlayer = Framework.GetPlayerFromId(src)
-- 	local vehicules = getPlayerVehicles(xPlayer.characterId)
-- 	local plate = vehicleProps.plate;
	
-- 	for _,v in pairs(vehicules) do
-- 		if(plate == v.plate)then
-- 			isFound = true
-- 			break
-- 		end		
-- 	end
-- 	cb(isFound)
-- end)

-- function getPlayerVehicles(characterId)
-- 	local vehicles = {}
-- 	local data = MySQL.Sync.fetchAll("SELECT * FROM character_vehicles WHERE characterId = ?",{characterId})	
-- 	for _,v in pairs(data) do
-- 		local vehicle = json.decode(v.vehicle)
-- 		table.insert(vehicles, {id = v.id, plate = vehicle.plate})
-- 	end
-- 	return vehicles
-- end