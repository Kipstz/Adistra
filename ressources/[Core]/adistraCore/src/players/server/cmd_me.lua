RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(players, text, t)
    local _src = source
    local xPlayer = Framework.GetPlayerFromId(_src)
    if text and string.match(text, "img src") then
        DropPlayer(source, 'Caractère Invalide')
        return
    end
    for i = 1, #players do
        TriggerClientEvent('3dme:shareDisplay', players[i], text, source, t)
    end
end)