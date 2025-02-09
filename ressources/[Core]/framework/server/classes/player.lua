
function CreateExtendedPlayer(playerId, uniqueId, identifier, name, group, coins)
	local self = {}

	self.playerId = playerId;
	self.source = playerId;
	self.uniqueId = uniqueId;
	self.identifier = identifier;
	self.name = name;
	self.group = group;
	self.coins = coins;

	self.license = 'license:'..identifier;
	self.characterId = 0;

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.kick(reason)
		print("UTILISATION DU KICK FRAMEWORK")
		-- DropPlayer(self.source, reason)
	end

	function self.getIdentifier()
		return self.identifier
	end

	function self.setGroup(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.license, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
		TriggerEvent('framework:setgroup', self.license, self.group)
	end

	function self.getGroup()
		return self.group
	end

	function self.getName()
		return self.name
	end

	function self.setName(newName)
		self.name = newName
	end

	function self.showNotification(msg)
		self.triggerEvent('framework:showNotification', msg)
	end

	function self.showHelpNotification(msg, thisFrame, beep, duration)
		self.triggerEvent('framework:showHelpNotification', msg, thisFrame, beep, duration)
	end

	function self.getCoins()
		return self.coins
	end

	function self.addCoins(coins)
		self.coins = self.coins + coins

		self.triggerEvent('framework:setCoins', self.coins)
	end

	function self.removeCoins(coins)
		self.coins = self.coins - coins

		if self.coins < 0 then
			self.coins = 0
		end

		self.triggerEvent('framework:setCoins', self.coins)
	end

	function self.setCoins(coins)
		self.coins = coins

		if self.coins < 0 then
			self.coins = 0
		end

		self.triggerEvent('framework:setCoins', self.coins)
	end

	function self.setCharacterId(id)
		self.characterId = id
	end

	return self
end
