
Instance = {}

Instance.instancedPlayers, Instance.registeredInstanceTypes, Instance.playersToHide = {}, {}, {}
Instance.instanceInvite, Instance.insideInstance = nil, false;

CreateThread(function()
	while true do
		wait = 5000;

		if Instance.instanceInvite then
			wait = 1;
			Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour entrer dans l'instance")

			if IsControlJustReleased(0, 38) then
				Instance:EnterInstance(Instance.instanceInvite)
				Framework.ShowNotification("Vous êtes entré dans l'instance")
				Instance.instanceInvite = nil;
			end
		end
		Wait(wait)
	end
end)

-- -- Instance players
-- CreateThread(function()
-- 	while true do
-- 		Wait(1000)
-- 		Instance.playersToHide = {}

-- 		if Instance.instance.host then
-- 			for k, v in ipairs(GetActivePlayers()) do
-- 				Instance.playersToHide[GetPlayerServerId(v)] = true
-- 			end

-- 			for k, v in ipairs(Instance.instance.players) do
-- 				Instance.playersToHide[v] = nil
-- 			end
-- 		else
-- 			for k, v in pairs(Instance.instancedPlayers) do
-- 				Instance.playersToHide[k] = true
-- 			end
-- 		end
-- 	end
-- end)

-- CreateThread(function()
-- 	while true do
-- 		wait = 2000;

-- 		local playerPed = PlayerPedId()

-- 		if next(Instance.playersToHide) then
-- 			wait = 10;

-- 			for k, v in pairs(Instance.playersToHide) do
-- 				local player = GetPlayerFromServerId(k)
	
-- 				if NetworkIsPlayerActive(player) then
-- 					local otherPlayerPed = GetPlayerPed(player)
-- 					SetEntityVisible(otherPlayerPed, false, false)
-- 					SetEntityNoCollisionEntity(playerPed, otherPlayerPed, false)
-- 				end
-- 			end
-- 		end

-- 		Wait(wait)
-- 	end
-- end)

CreateThread(function()
	Instance:RegisterInstanceType('default')
	TriggerEvent('instance:loaded')
end)

