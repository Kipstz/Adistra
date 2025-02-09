
function Instance:GetInstancedPlayers()
	local players = {}

	for k, v in pairs(Instance.instances) do
		for k2, v2 in ipairs(v.players) do
			players[v2] = true;
		end
	end
	return players
end

function Instance:CreateInstance(type, player, data)
	Instance.instances[player] = {
		type = type,
		host = player,
		players = {},
		data = data
	}

	TriggerEvent('instance:onCreate', Instance.instances[player])
	TriggerClientEvent('instance:onCreate', player, Instance.instances[player])
	TriggerClientEvent('instance:onInstancedPlayersData', -1, Instance:GetInstancedPlayers())
end

function Instance:CloseInstance(instance)
	if Instance.instances[instance] then
		for i = 1, #Instance.instances[instance].players do
			SetPlayerRoutingBucket(Instance.instances[instance].players[i], 0)
			TriggerClientEvent('instance:onClose', Instance.instances[instance].players[i])
		end

		Instance.instances[instance] = nil;

		TriggerClientEvent('instance:onInstancedPlayersData', -1, Instance:GetInstancedPlayers())
		TriggerEvent('instance:onClose', instance)
	end
end

function Instance:AddPlayerToInstance(instance, player)
	local found = false;

	for i = 1, #Instance.instances[instance].players do
		if Instance.instances[instance].players[i] == player then
			found = true;
			break
		end
	end

	if not found then
		table.insert(Instance.instances[instance].players, player)
	end

	SetPlayerRoutingBucket(player, Instance.instances[instance].data.instanceId)
	TriggerClientEvent('instance:onEnter', player, Instance.instances[instance])

	for i = 1, #Instance.instances[instance].players do
		if Instance.instances[instance].players[i] ~= player then
			TriggerClientEvent('instance:onPlayerEntered', Instance.instances[instance].players[i], Instance.instances[instance], player)
		end
	end

	TriggerClientEvent('instance:onInstancedPlayersData', -1, Instance:GetInstancedPlayers())
end

function Instance:RemovePlayerFromInstance(instance, player)
	if Instance.instances[instance] then
		TriggerClientEvent('instance:onLeave', player, Instance.instances[instance])

		if Instance.instances[instance].host == player then
			for i = 1, #Instance.instances[instance].players do
				if Instance.instances[instance].players[i] ~= player then
					SetPlayerRoutingBucket(Instance.instances[instance].players[i], 0)
					TriggerClientEvent('instance:onPlayerLeft', Instance.instances[instance].players[i], Instance.instances[instance], player)
				end
			end

			Instance:CloseInstance(instance)
		else
			for i = 1, #Instance.instances[instance].players do
				if Instance.instances[instance].players[i] == player then
					Instance.instances[instance].players[i] = nil;
				end
			end

			for i = 1, #Instance.instances[instance].players do
				if Instance.instances[instance].players[i] ~= player then
					SetPlayerRoutingBucket(Instance.instances[instance].players[i], 0)
					TriggerClientEvent('instance:onPlayerLeft', Instance.instances[instance].players[i], Instance.instances[instance], player)
				end
			end

			TriggerClientEvent('instance:onInstancedPlayersData', -1, Instance:GetInstancedPlayers())
		end
	end
end

function Instance:InvitePlayerToInstance(instance, type, player, data)
	TriggerClientEvent('instance:onInvite', player, instance, type, data)
end