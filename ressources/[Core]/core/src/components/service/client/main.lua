
RegisterNetEvent('service:notifyAllInService')
AddEventHandler('service:notifyAllInService', function(notification, targetId)
	local target = GetPlayerFromServerId(targetId)

	if target < 1 then
		return
	end

	local targetPed = GetPlayerPed(target)
	local mugshot, mugshotStr = Framework.Game.GetPedMugshot(targetPed)

	Framework.ShowAdvancedNotification(notification.title, notification.subject, notification.msg, mugshotStr, notification.iconType)
	UnregisterPedheadshot(mugshot)
end)