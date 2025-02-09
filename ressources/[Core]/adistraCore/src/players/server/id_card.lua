TriggerEvent('framework:init', function(obj) Framework = obj end)

RegisterServerEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(ID, targetID, type)
	local characterId = Framework.GetPlayerFromId(ID).characterId;
	local src = Framework.GetPlayerFromId(targetID).source;
	local show = false;
	MySQL.Async.fetchAll('SELECT identity FROM characters WHERE characterId = @characterId', {['@characterId'] = characterId}, function (user)
		if (user[1] ~= nil) then
			user = json.decode(user[1].identity)
			MySQL.Async.fetchAll('SELECT type FROM character_licenses WHERE characterId = @characterId', {['@characterId'] = characterId},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('jsfour-idcard:open', src, array, type)
				else
					TriggerClientEvent('framework:showNotification', src, "Vous n'avez pas cette license..")
				end
			end)
		end
	end)
end)
