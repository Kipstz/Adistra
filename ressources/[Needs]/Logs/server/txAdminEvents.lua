--names = {}
--CreateThread(function()
--	while true do
--		Wait(100)
--		for k,v in pairs(GetPlayers()) do
--			names[v] = GetPlayerName(v)
--		end
--	end
--end)


AddEventHandler('txAdmin:events:scheduledRestart', function(data)
	CreateLog({EmbedMessage = ("Staff : %s\n Action: Programation d'un reboot dans: `%s`"):format(data.author, SecondsToClock(data.secondsRemaining)), channel = 'txAdmin'})
end)

--AddEventHandler('txAdmin:events:playerKicked', function(data)
--	--CreateLog({EmbedMessage = ("**%s** Kicked **%s**\nReason: `%s`"):format(data.author, names[data.target], data.reason), channel = 'txAdmin'})
--	CreateLog({EmbedMessage = ("**%s** Kicked **%s**\nReason: `%s`"):format(data.author, data.target, data.reason), channel = 'txAdmin'})
--end)

AddEventHandler('txAdmin:events:playerWarned', function(data)
	CreateLog({EmbedMessage = ("**%s** Warned **%s**\nAction Id: `%s`\nReason: `%s`"):format(data.author, GetPlayerName(data.target), data.actionId, data.reason), player_id = data.target, channel = 'txAdmin'})
end)

AddEventHandler('txAdmin:events:playerBanned', function(data)
	if data.expiration == false then
		CreateLog({EmbedMessage = ("**%s** Banned **%s**\nAction Id: `%s`\nReason: `%s`\nExpire: `Perm`"):format(data.author, data.target, data.actionId, data.reason), channel = 'txAdmin'})
	else
		CreateLog({EmbedMessage = ("**%s** Banned **%s**\nAction Id: `%s`\nReason: `%s`\nExpire: `%s`"):format(data.author, data.target, data.actionId, data.reason, data.expiration), channel = 'txAdmin'})
	end
end)

AddEventHandler('txAdmin:events:playerWhitelisted', function(data)
	CreateLog({EmbedMessage = ("**%s** Whitelisted `%s`\nAction Id: `%s`"):format(data.author, data.target, data.actionId), channel = 'txAdmin'})
end)

AddEventHandler('txAdmin:event:configChanged', function()
	CreateLog({EmbedMessage = "The server.cfg file has been updated.", player_id = data.target, channel = 'txAdmin'})
end)

AddEventHandler('txAdmin:events:healedPlayer', function(data)
	if data.id == -1 then
		CreateLog({EmbedMessage = ("The whole server was Healed"), channel = 'txAdmin'})
	else
		CreateLog({EmbedMessage = ("**%s** was Healed."):format(GetPlayerName(data.id)), player_id = data.id, channel = 'txAdmin'})
	end
end)

AddEventHandler('txAdmin:events:announcement', function(data)
	CreateLog({EmbedMessage = ("Staff: %s\nAnnonce TxAdmin: `%s`"):format(data.author, data.message), player_id = data.id, channel = 'txAdmin'})
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function(data)
	CreateLog({EmbedMessage = ("Staff : %s\nAction: `Stop/Restart serveur via TxAdmin`"):format(data.author), player_id = data.id, channel = 'txAdmin'})
end)

function SecondsToClock(sec)
	local minutes = math.floor(sec / 60)
	local seconds = sec - minutes * 60
	if minutes == 0 then
		return string.format("%d seconds.", seconds)
	else
		return string.format("%d minutes, %d seconds.", minutes, seconds)
	end
end

