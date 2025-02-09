
TriggerEvent('framework:init', function(obj) Framework = obj end)

DoorLock = {}

RegisterServerEvent('nui_doorlock:updateState')
AddEventHandler('nui_doorlock:updateState', function(doorID, locked, src, usedLockpick)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

	if type(doorID) ~= 'number' then
		print(('nui_doorlock: %s (%s) didn\'t send a number! (Sent %s)'):format(xPlayer.name, xPlayer.identifier, doorID))
		return
	end

	if type(locked) ~= 'boolean' then
		print(('nui_doorlock: %s (%s) attempted to update invalid state! (Sent %s)'):format(xPlayer.name, xPlayer.identifier, locked))
		return
	end

	if not Config.DoorList[doorID] then
		print(('nui_doorlock: %s (%s) attempted to update invalid door! (Sent %s)'):format(xPlayer.name, xPlayer.identifier, doorID))
		return
	end
	
	if not DoorLock:isAuthorized(xPlayer, Config.DoorList[doorID], usedLockpick) then
		return
	end

	Config.DoorList[doorID].locked = locked;

	if not src then 
		TriggerClientEvent('nui_doorlock:setState', -1, playerId, doorID, locked)
	else 
		TriggerClientEvent('nui_doorlock:setState', -1, playerId, doorID, locked, src) 
	end

	if Config.DoorList[doorID].autoLock then
		SetTimeout(Config.DoorList[doorID].autoLock, function()
			if Config.DoorList[doorID].locked == true then return end
			Config.DoorList[doorID].locked = true;
			TriggerClientEvent('nui_doorlock:setState', -1, -1, doorID, true)
		end)
	end
end)

Framework.RegisterServerCallback('nui_doorlock:getDoorList', function(source, cb)
	cb(Config.DoorList)
end)