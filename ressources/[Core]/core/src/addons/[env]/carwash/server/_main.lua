
RegisterServerEvent('carwash:checkMoney')
AddEventHandler('carwash:checkMoney', function()
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	local price = tonumber(Config['carwash'].price)

	if xPlayer['accounts'].getMoney() >= price then
		xPlayer['accounts'].removeMoney(price)
		TriggerClientEvent('carwash:startLavage', src)
	else
		xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !~s~")
	end	
end)