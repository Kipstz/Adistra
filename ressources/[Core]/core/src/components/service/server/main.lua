Service = {}
local InService = {}
local MaxInService = {}

function Service:GetInServiceCount(name)
	local count = 0

	if InService[name] ~= nil then
		for k, v in pairs(InService[name]) do
			if v == true then
				count = count + 1
			end
		end
	else
		print("^1Erreur SERVICE: Service Invalide "..name.. "^0")
	end

	return count
end

AddEventHandler('service:activateService', function(name, max)
	InService[name] = {}
	MaxInService[name] = max
end)

RegisterServerEvent('service:disableService')
AddEventHandler('service:disableService', function(name)
	InService[name][source] = nil
end)

RegisterServerEvent('service:notifyAllInService')
AddEventHandler('service:notifyAllInService', function(notification, name)
	local src = source;
	if InService[name] ~= nil then
		for k, v in pairs(InService[name]) do
			if v == true then
				TriggerClientEvent('service:notifyAllInService', k, notification, src)
			end
		end
	else
		print("^1Erreur SERVICE: erreur avec le service "..name.."^0")
	end
end)

Framework.RegisterServerCallback('service:enableService', function(source, cb, name)
	local inServiceCount = Service:GetInServiceCount(name)

	--if inServiceCount >= MaxInService[name] then
	--	cb(false, MaxInService[name], inServiceCount)
	--else
		InService[name][source] = true
		cb(true, MaxInService[name], inServiceCount)
	--end
end)

Framework.RegisterServerCallback('service:isInService', function(source, cb, name)
	local isInService = false

	if InService[name][source] then
		isInService = true
	end

	cb(isInService)
end)

Framework.RegisterServerCallback('service:getInServiceList', function(source, cb, name)
	cb(InService[name])
end)

AddEventHandler('playerDropped', function()
	local _source = source

	for k, v in pairs(InService) do
		if v[_source] == true then
			v[_source] = nil
		end
	end

	comaCalls[_source] = nil
end)

newComa = false
Citizen.CreateThread(function()
	while(true) do
		Citizen.Wait(15000)

		local job = 'ambulance'
		if(InService[job]) then
			for source, _ in pairs(InService[job]) do
				TriggerClientEvent('AmbulanceJob:updateCalls', source, comaCalls)
				if(newComa) then
					TriggerClientEvent('framework:showNotification', source, 'Un nouvel appel coma vient d\'arriver !')
					newComa = false
				end
			end
		end
	end
end)

RegisterNetEvent('ambulanceJob:takeCall')
AddEventHandler('ambulanceJob:takeCall', function(index)
    local _source = source
	comaCalls[index] = nil

	local job = 'ambulance'
	if(InService[job]) then
		for source, _ in pairs(InService[job]) do
			TriggerClientEvent('AmbulanceJob:updateCalls', source, comaCalls)
		end
	end
end)

exports("CountOnService", function(serviceName)
	local count = 0

	if InService[serviceName] ~= nil then
		for _ in pairs(InService[serviceName]) do count = count + 1 end
	end
	return count
end)