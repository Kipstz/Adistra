
function CreateExtendedIdentity(playerId, characterId, identity)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.identity = identity;

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.getIdentity()
		return self.identity
	end

	function self.getFullName()
		local fullName = self.identity.firstname..' '..self.identity.lastname
		return fullName
	end

	return self
end
