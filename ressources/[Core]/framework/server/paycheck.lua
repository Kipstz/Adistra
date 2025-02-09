function Framework.StartAideCheck()
	CreateThread(function()
		while true do
			Wait(Config.AidecheckInterval)
			local xPlayers = Framework.GetExtendedPlayers()

			for _, player in pairs(xPlayers) do
				local xPlayer = Framework.GetPlayerFromId(player.source)
				if xPlayer['accounts'] ~= nil then
					xPlayer['accounts'].addAccountMoney('bank', Config.Aide)
					TriggerClientEvent('framework:showAdvancedNotification', xPlayer.source, Config.ServerName2, "Banque", "Vous avez reçu une aide de l'état de "..Config.Aide.."$", 'CHAR_BANK_MAZE', 9)
				end
			end
		end
	end)
end
