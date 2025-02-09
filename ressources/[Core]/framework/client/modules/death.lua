CreateThread(function()
	local isDead = false

	while true do
		local sleep = 1500
		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isDead then
				sleep = 0
				isDead = true

				local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

				if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
				else
					PlayerKilled(deathCause)
				end

			elseif not IsPedFatallyInjured(playerPed) and isDead then
				sleep = 0
				isDead = false
			end
		end
	Wait(sleep)
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = {x = Framework.Math.Round(victimCoords.x, 1), y = Framework.Math.Round(victimCoords.y, 1), z = Framework.Math.Round(victimCoords.z, 1)},
		killerCoords = {x = Framework.Math.Round(killerCoords.x, 1), y = Framework.Math.Round(killerCoords.y, 1), z = Framework.Math.Round(killerCoords.z, 1)},

		killedByPlayer = true,
		deathCause = deathCause,
		distance = Framework.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('framework:onPlayerDeath', data)
	TriggerServerEvent('framework:onPlayerDeath', data)
end

function PlayerKilled(deathCause)
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(playerPed)

	local data = {
		victimCoords = {x = Framework.Math.Round(victimCoords.x, 1), y = Framework.Math.Round(victimCoords.y, 1), z = Framework.Math.Round(victimCoords.z, 1)},

		killedByPlayer = false,
		deathCause = deathCause
	}

	TriggerEvent('framework:onPlayerDeath', data)
	TriggerServerEvent('framework:onPlayerDeath', data)
end
