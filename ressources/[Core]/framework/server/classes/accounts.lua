
function CreateExtendedAccounts(playerId, characterId, accounts)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.accounts = accounts;

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.getAccounts(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	function self.getAccount(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v, true
			end
		end
	end

	function self.getMoney()
		return self.getAccount('money').money
	end

	function self.setMoney(money)
		money = Framework.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	function self.addMoney(money)
		money = Framework.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	function self.removeMoney(money)
		money = Framework.Math.Round(money)
		self.removeAccountMoney('money', money)
	end

	function self.setAccountMoney(accountName, money)
		if money >= 0 then
			local account, exist = self.getAccount(accountName)

			if account then
				local newMoney = Framework.Math.Round(money)
				account.money = newMoney

				if exist then self.accounts[accountName].money = newMoney end

				self.triggerEvent('framework:setAccountMoney', account)
			end
		end
	end

	function self.addAccountMoney(accountName, money)
		if money > 0 then
			local account, exist = self.getAccount(accountName)

			if account then
				local newMoney = account.money + Framework.Math.Round(money)
				account.money = newMoney

				if exist then self.accounts[accountName].money = newMoney end

				self.triggerEvent('framework:setAccountMoney', account)
			end
		end
	end

	function self.removeAccountMoney(accountName, money)
		if money > 0 then
			local account, exist = self.getAccount(accountName)

			if account then
				local newMoney = account.money - Framework.Math.Round(money)
				account.money = newMoney

				if exist then self.accounts[accountName].money = newMoney end

				self.triggerEvent('framework:setAccountMoney', account)
			end
		end
	end

	return self
end
