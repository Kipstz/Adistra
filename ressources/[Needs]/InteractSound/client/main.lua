
local standardVolumeOutput = 1.0

RegisterNetEvent('InteractSound_CL:PlayOnOne')
AddEventHandler('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
	SendNUIMessage({
		transactionType = 'playSound',
		transactionFile = soundFile,
		transactionVolume = soundVolume
	})
end)

RegisterNetEvent('InteractSound_CL:PlayOnAll')
AddEventHandler('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
	SendNUIMessage({
		transactionType = 'playSound',
		transactionFile = soundFile,
		transactionVolume = soundVolume
	})
end)

RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
	local senderId = GetPlayerFromServerId(playerNetId)

	if (senderId ~= PlayerId() and senderId > 0) or (GetPlayerServerId(PlayerId()) == playerNetId) then
		local lCoords = GetEntityCoords(PlayerPedId(), false)
		local eCoords = GetEntityCoords(GetPlayerPed(senderId), false)
		local distIs = Vdist(lCoords, eCoords)

		if (distIs <= maxDistance) then
			SendNUIMessage({
				transactionType = 'playSound',
				transactionFile = soundFile,
				transactionVolume = soundVolume
			})
		end
	end
end)

