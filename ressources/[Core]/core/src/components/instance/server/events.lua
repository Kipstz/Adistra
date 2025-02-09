
AddEventHandler('playerDropped', function(reason)
	if Instance.instances[source] then
		Instance:CloseInstance(source)
	end
end)

RegisterServerEvent('instance:create')
AddEventHandler('instance:create', function(type, data)
	Instance:CreateInstance(type, source, data)
end)

RegisterServerEvent('instance:close')
AddEventHandler('instance:close', function()
	Instance:CloseInstance(source)
end)

RegisterServerEvent('instance:enter')
AddEventHandler('instance:enter', function(instance)
	Instance:AddPlayerToInstance(instance, source)
end)

RegisterServerEvent('instance:leave')
AddEventHandler('instance:leave', function(instance)
	Instance:RemovePlayerFromInstance(instance, source)
end)

RegisterServerEvent('instance:invite')
AddEventHandler('instance:invite', function(instance, type, player, data)
	Instance:InvitePlayerToInstance(instance, type, player, data)
end)