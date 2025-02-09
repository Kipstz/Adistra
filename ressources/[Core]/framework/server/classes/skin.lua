
function CreateExtendedSkin(playerId, characterId, skin)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.skin = skin;

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.getSkin()
		return self.skin
	end

	function self.setSkin(skin)
		self.skin = skin
	end

	return self
end
