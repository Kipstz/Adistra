
RegisterNetEvent('framework:setAccountMoney')
AddEventHandler('framework:setAccountMoney', function(account)
	for k,v in ipairs(Framework.PlayerData.accounts) do
		if v.name == account.name then
			Framework.PlayerData.accounts[k] = account
			break
		end
	end
	
	Framework.PlayerData.accounts[account.name].money = account.money
end)