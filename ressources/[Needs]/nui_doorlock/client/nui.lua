
RegisterNUICallback('newDoor', function(data, cb)
	receivedDoorData = true
	arg = data
	closeNUI()
end)

RegisterNUICallback('close', function(data, cb)
	closeNUI()
end)

function closeNUI()
	SetNuiFocus(false, false)
	SendNUIMessage({type = "newDoorSetup", enable = false})
	receivedDoorData = nil
end

RegisterCommand('-nui', function(playerId, args, rawCommand)
	closeNUI()
end, false)