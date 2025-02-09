

AddEventHandler('instance:get', function(cb)
	cb(Instance.instance)
end)

AddEventHandler('instance:create', function(type, data)
	Instance:CreateInstance(type, data)
end)

AddEventHandler('instance:close', function()
	Instance:CloseInstance()
end)

AddEventHandler('instance:enter', function(_instance)
	Instance:EnterInstance(_instance)
end)

AddEventHandler('instance:leave', function()
	Instance:LeaveInstance()
end)

AddEventHandler('instance:invite', function(type, player, data)
	Instance:InviteToInstance(type, player, data)
end)

AddEventHandler('instance:registerType', function(name, enter, exit)
	Instance:RegisterInstanceType(name, enter, exit)
end)

RegisterNetEvent('instance:onInstancedPlayersData')
AddEventHandler('instance:onInstancedPlayersData', function(_instancedPlayers)
	Instance.instancedPlayers = _instancedPlayers;
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(_instance)
	Instance.instance = {}
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(_instance)
	Instance.instance = _instance;
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onLeave', function(_instance)
	Instance.instance = {}
end)

RegisterNetEvent('instance:onClose')
AddEventHandler('instance:onClose', function(_instance)
	Instance.instance = {}
end)

RegisterNetEvent('instance:onPlayerEntered')
AddEventHandler('instance:onPlayerEntered', function(_instance, player)
	Instance.instance = _instance;
	local playerName = GetPlayerName(GetPlayerFromServerId(player))
	Framework.ShowNotification("~g~Le Joueur ~r~"..playerName.."~g~ est entré dans l'instance !")
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(_instance, player)
	Instance.instance = _instance;
	local playerName = GetPlayerName(GetPlayerFromServerId(player))
	Framework.ShowNotification("~g~Le Joueur ~r~"..playerName.."~g~ est sortie de l'instance !")
end)

RegisterNetEvent('instance:onInvite')
AddEventHandler('instance:onInvite', function(_instance, type, data)
	Instance.instanceInvite = {
		type = type,
		host = _instance,
		data = data
	}

	CreateThread(function()
		Wait(10000)

		if Instance.instanceInvite then
			Framework.ShowNotification("Invitation expirée")
			Instance.instanceInvite = nil;
		end
	end)
end)
