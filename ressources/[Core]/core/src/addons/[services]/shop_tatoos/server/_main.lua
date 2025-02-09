
Framework.RegisterServerCallback('shop_tattoos:getPlayerTattoos', function(source, cb)
	local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM characters WHERE characterId = ?', {xPlayer.characterId}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

Framework.RegisterServerCallback('shop_tattoos:haveMoney', function(src, cb, info)
    local xPlayer = Framework.GetPlayerFromId(src);
    local price, method = tonumber(info.price), info.method;
    if xPlayer['accounts'].accounts[method].money >= tonumber(price) then 
        xPlayer['accounts'].removeAccountMoney(method, tonumber(price))
        local tattoos = json.encode(info.tattoos)

        MySQL.query("SELECT tattoos FROM characters WHERE characterId = ?", {xPlayer.characterId}, function(result)
            MySQL.query("UPDATE characters SET tattoos = ? WHERE characterId = ?", {tattoos, xPlayer.characterId})
        end)
        xPlayer.showNotification("Vous avez payé ~g~"..price.."$~s~.")
        cb(true) 
    else 
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
        cb(false)
    end
end)