
RegisterServerEvent('animCarry:sync')
AddEventHandler('animCarry:sync', function(target, params)
    local src = source;
	if target ~= -1 then
        TriggerClientEvent('animCarry:syncTarget', target, src, params)
        TriggerClientEvent('animCarry:syncMe', source, params)
    end
end)

RegisterServerEvent('animCarry:stop')
AddEventHandler('animCarry:stop', function(targetSrc)
    if targetSrc ~= -1 then
        TriggerClientEvent('animCarry:stop', targetSrc)
    end
end)

RegisterServerEvent('carry:ban')
AddEventHandler('carry:ban', function()
    local _source = source
    
    exports['ac']:screenshotPlayer(_source, function(url)
        print('got url of screnshot: '..url..' from player: '.._source)
    end)
    Citizen.Wait(5000)
    exports['ac']:fg_BanPlayer(_source, 'Utilisation inconvenable de la commande porter', true)
end)