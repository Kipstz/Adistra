
CreateThread(function()
	while Framework == nil do
		TriggerEvent('framework:init', function(obj) Framework = obj end)
        Wait(10)
	end

	Framework.PlayerData = Framework.GetPlayerData()

	while not Framework.PlayerLoaded do Wait(100) end
	Citizen.CreateThread(DoorLoop)
end)

RegisterNetEvent('framework:playerLoaded')
AddEventHandler('framework:playerLoaded', function(xPlayer)
	Framework.PlayerLoaded = true;
	Framework.PlayerData = xPlayer;
end)

RegisterNetEvent('framework:onPlayerLogout')
AddEventHandler('framework:onPlayerLogout', function(playerData)
	Framework.PlayerLoaded = false
	Framework.PlayerData = {}
end)

RegisterCommand('doorlock', function()
	if closestDoor.id and not IsEntityDead(PlayerPedId()) then
		local veh = GetVehiclePedIsIn(PlayerPedId())
		if veh then
			Citizen.CreateThread(function()
				local counter = 0
				local siren = IsVehicleSirenOn(veh)
				repeat
					DisableControlAction(0, 86, true)
					SetHornEnabled(veh, false)
					if not siren then SetVehicleSiren(veh, false) end
					counter = counter + 1
					Citizen.Wait(0)
				until (counter == 100)
				SetHornEnabled(veh, true)
			end)
		end
		local locked = not closestDoor.data.locked
		if closestDoor.data.audioRemote then src = NetworkGetNetworkIdFromEntity(PlayerPedId()) else src = nil end
		TriggerServerEvent('nui_doorlock:updateState', closestDoor.id, locked, src) -- Broadcast new state of the door to everyone
	end
end)

TriggerEvent("chat:removeSuggestion", "/doorlock")
RegisterKeyMapping('doorlock', '[Doorlock] Intéragir avec les portes', 'keyboard', 'e')


--[[RegisterNetEvent('nui_doorlock:lockpick') -- Set up your own lockpick event here
AddEventHandler('nui_doorlock:lockpick', function(data)
	local locked = not closestDoor.data.locked
	TriggerServerEvent('nui_doorlock:updateState', closestDoor.id, locked, nil, true) -- Broadcast new state of the door to everyone
end)]]