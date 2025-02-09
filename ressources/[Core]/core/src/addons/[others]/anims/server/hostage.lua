
RegisterServerEvent('animHostage:sync')
AddEventHandler('animHostage:sync', function(target, params)
	if target ~= -1 then
        TriggerClientEvent('animHostage:syncTarget', target, source, params)
        TriggerClientEvent('animHostage:syncMe', source, params)
    end
end)

RegisterServerEvent('animHostage:stop')
AddEventHandler('animHostage:stop', function(targetSrc)
    if targetSrc ~= -1 then
        TriggerClientEvent('animHostage:cl_stop', targetSrc)
    end
end)
