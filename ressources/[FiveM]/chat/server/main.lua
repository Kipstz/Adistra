RegisterServerEvent('__cfx_internal:commandFallback')
AddEventHandler('__cfx_internal:commandFallback', function(command)
	local _source = source
	local name = GetPlayerName(_source)
	TriggerEvent('chatMessage', _source, name, '/' .. command)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, {255, 255, 255}, '/' .. command)
	end

	CancelEvent()
end)

AddEventHandler('onServerResourceStart', function(resName)
	Citizen.Wait(500)
	local players = GetPlayers()

	for i = 1, #players, 1 do
		refreshCommands(players[i])
	end
end)

function refreshCommands(playerId)
	local registeredCommands = GetRegisteredCommands()
	local suggestions = {}

	for i = 1, #registeredCommands do
		if IsPlayerAceAllowed(playerId, ('command.%s'):format(registeredCommands[i].name)) then
			table.insert(suggestions, {
				name = '/' .. registeredCommands[i].name,
				help = ''
			})
		end
	end

	TriggerClientEvent('chat:addSuggestions', playerId, suggestions)
end