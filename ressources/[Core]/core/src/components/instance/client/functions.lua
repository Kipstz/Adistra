
function Instance:CreateInstance(type, data)
	TriggerServerEvent('instance:create', type, data)
end

function Instance:CloseInstance()
	Instance.instance = {}
	TriggerServerEvent('instance:close')
	Instance.insideInstance = false;
end

function Instance:EnterInstance(instance)
	Instance.insideInstance = true;
	TriggerServerEvent('instance:enter', instance.host)

	if Instance.registeredInstanceTypes[instance.type].enter then
		Instance.registeredInstanceTypes[instance.type].enter(instance)
	end
end

function Instance:LeaveInstance()
	if Instance.instance and Instance.instance.host then
		if #Instance.instance.players > 1 then
			Framework.ShowNotification("Vous avez quitter l'instance")
		end

		if Instance.registeredInstanceTypes[Instance.instance.type].exit then
			Instance.registeredInstanceTypes[Instance.instance.type].exit(Instance.instance)
		end

		TriggerServerEvent('instance:leave', Instance.instance.host)
	end
	Instance.insideInstance = false;
end

function Instance:InviteToInstance(type, player, data)
	TriggerServerEvent('instance:invite', Instance.instance.host, type, player, data)
end

function Instance:RegisterInstanceType(type, enter, exit)
	Instance.registeredInstanceTypes[type] = {
		enter = enter,
		exit = exit
	}
end