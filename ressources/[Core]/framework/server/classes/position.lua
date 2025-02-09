
function CreateExtendedPosition(playerId, characterId, position)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.position = position;

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.getPosition(vector)
		if vector then
			return vector3(self.position.x, self.position.y, self.position.z)
		else
			return self.position
		end
	end

	function self.setCoords(coords)
		self.updateCoords(coords)
		self.triggerEvent('framework:teleport', coords)
	end

	function self.updateCoords(coords)
		self.position = {x = Framework.Math.Round(coords.x, 1), y = Framework.Math.Round(coords.y, 1), z = Framework.Math.Round(coords.z, 1), heading = Framework.Math.Round(coords.heading or 0.0, 1)}
	end

	return self
end

function Framework.SyncPosition()
	local xPlayers = Framework.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local xPlayer = Framework.GetPlayerFromId(xPlayers[i])

		if xPlayer and xPlayer['position'] then
			local plyPed = GetPlayerPed(xPlayer.source)

			if DoesEntityExist(plyPed) then
				local lastCoords = GetEntityCoords(plyPed)
				local lastHeading = GetEntityHeading(plyPed)

				if lastCoords ~= nil then
					xPlayer['position'].updateCoords({ x = lastCoords.x, y = lastCoords.y, z = lastCoords.z, heading = lastHeading})
				end
			end
		end
	end
end

function Framework.StartPositionSync()
	function updateData()
		Framework.SyncPosition()
	end

	SetTimeout(1000*45, updateData)
end