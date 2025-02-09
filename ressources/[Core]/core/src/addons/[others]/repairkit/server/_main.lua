
RepairKit = {}

Framework.ITEMS:RegisterUsableItem('fixkit', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)
	TriggerClientEvent('repairkit:useFixKit', src)
end)

Framework.ITEMS:RegisterUsableItem('carokit', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)
	TriggerClientEvent('repairkit:useCaroKit', src)
end)

Framework.ITEMS:RegisterUsableItem('blowpipe', function(src)
	local xPlayer = Framework.GetPlayerFromId(src)
	TriggerClientEvent('repairkit:useBlowPipe', src)
end)

RegisterServerEvent('repairkit:removeFixKit')
AddEventHandler('repairkit:removeFixKit', function()
    local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
    xPlayer['inventory'].removeInventoryItem('fixkit', 1)
end)

RegisterServerEvent('repairkit:removeCaroKit')
AddEventHandler('repairkit:removeCaroKit', function()
    local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
    xPlayer['inventory'].removeInventoryItem('carokit', 1)
end)

RegisterServerEvent('repairkit:removeBlowPipe')
AddEventHandler('repairkit:removeBlowPipe', function()
    local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
    xPlayer['inventory'].removeInventoryItem('blowpipe', 1)
end)