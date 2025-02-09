
Framework.RegisterServerCallback('keys:haveKey', function(src, cb, plate)
    local src = src;
	local xPlayer = Framework.GetPlayerFromId(src);

	MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE characterId = ? AND plate = ?', {xPlayer.characterId, plate}, function(result)
		local found = false;
		if result[1] then found = true; end
		cb(found)
	end)
end)
