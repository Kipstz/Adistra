TriggerEvent('framework:init', function(obj) Framework = obj end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
    Wait(45000)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer['accounts'].getAccount('money').money > 15000000 then
        exports['Logs']:createLog({EmbedMessage = "Suspection cheat, grosse somme d'argent", player_id = source, channel = 'cheatSuspect'})
    end
    if xPlayer['accounts'].getAccount('bank').money > 15000000 then
        exports['Logs']:createLog({EmbedMessage = "Suspection cheat, grosse somme d'argent", player_id = source, channel = 'cheatSuspect'})
    end
    if xPlayer['accounts'].getAccount('black_money').money > 15000000 then
        exports['Logs']:createLog({EmbedMessage = "Suspection cheat, grosse somme d'argent", player_id = source, channel = 'cheatSuspect'})
    end
end)