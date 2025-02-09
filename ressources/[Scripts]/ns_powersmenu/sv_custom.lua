
-- Choose or replace by the correct event/funciton for kill someone in your server, here's two presets, qb or esx 

RegisterServerEvent("PW2:KillPlayer")
AddEventHandler("PW2:KillPlayer", function(targetSrc)

	--TriggerClientEvent('hospital:client:KillPlayer', targetSrc) -- qb

    TriggerClientEvent('esx:killPlayer', targetSrc) -- esx

end)