Status = {}
Status.Players = {}

local function setPlayerStatus(xPlayer, data)
	data = data and json.decode(data) or {}

	Status.Players[xPlayer.source] = data;
	TriggerClientEvent("status:load", xPlayer.source, data)
end

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	Wait(15000)
	for _, xPlayer in pairs(Framework.Players) do
		MySQL.scalar('SELECT status FROM characters WHERE characterId = ?', { xPlayer.characterId }, function(result)
			setPlayerStatus(xPlayer, result)
		end)
	end
end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
	Wait(5000)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src);
	while xPlayer == nil do Wait(3000) end

	if xPlayer ~= nil then
		MySQL.scalar('SELECT status FROM characters WHERE characterId = ?', { xPlayer.characterId }, function(result)
			setPlayerStatus(xPlayer, result)
		end)
	end
end)

AddEventHandler('framework:playerDropped', function(playerId, reason)
	local xPlayer = Framework.GetPlayerFromId(playerId)
	local status = Status.Players[xPlayer.source]

	MySQL.update('UPDATE characters SET status = ? WHERE characterId = ?', { json.encode(status), xPlayer.characterId })
	Status.Players[xPlayer.source] = nil;
end)

RegisterNetEvent("status:get")
AddEventHandler("status:get", function(playerId, statusName, cb)
	local status = Status.Players[playerId]
	for i = 1, #status do
		if status[i].name == statusName then
			return cb(status[i])
		end
	end
end)

RegisterNetEvent("status:update")
AddEventHandler("status:update", function(status)
	Status.Players[source] = status;
end)

Framework.RegisterCommand('savestatus', { 'owner' }, function(xPlayer, args, showError)
	local parameters = {}
	for _, xPlayer in pairs(Framework.GetExtendedPlayers()) do
		local status = Status.Players[xPlayer.source]
		if status and next(status) then
			parameters[#parameters+1] = {json.encode(status), xPlayer.characterId}
		end
	end
	if #parameters > 0 then
		MySQL.prepare('UPDATE characters SET status = ? WHERE characterId = ?', parameters)
	end
end, true, {help = "Sauvegarder la faim et la soif", validate = true,
})