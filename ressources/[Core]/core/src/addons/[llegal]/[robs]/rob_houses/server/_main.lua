
RobHouses = {}

Framework.RegisterServerCallback('rob_houses:canRob', function(src, cb, robId)
    local src = src;
    local xPlayer = Framework.GetPlayerFromId(src)
    for k,v in pairs(Config['rob_houses'].localisations) do
        if k == robId then
            local cops = Service:GetInServiceCount(v.job)
            if cops ~= nil and cops >= Config['rob_houses'].requiredCops then
                if not v.robbed then
                    local hasCount = (xPlayer['inventory'].getInventoryItem(Config['rob_houses'].itemRequired).count > 0)
                    if hasCount then 
                        xPlayer['inventory'].removeInventoryItem(Config['rob_houses'].itemRequired, 1)
                        cb(true)
                    else
                        xPlayer.showNotification("~r~Vous n'avez pas l'item requis !~s~")
                        cb(false)
                    end
                else
                    xPlayer.showNotification("~r~Cette maison vient d'être cambriolée !~s~")
                    cb(false)
                end
            else
                xPlayer.showNotification("~r~Il n'y a pas asser de flics en ville !~s~")
                cb(false)
            end
        end
    end
end)

RegisterServerEvent('rob_houses:start')
AddEventHandler('rob_houses:start', function(robId)
    local src = source;
    Config['rob_houses'].localisations[robId].robbed = true;
    SetPlayerRoutingBucket(src, robId)
    TriggerClientEvent('rob_houses:notify', -1, robId, src)

    local second = 1000;
    local minute = 60 * second;
    local hour = 60 * minute;
    local cooldown = Config['rob_houses'].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second

    Wait(wait)
    Config['rob_houses'].localisations[robId].robbed = false;
end)

RegisterServerEvent('rob_houses:stop')
AddEventHandler('rob_houses:stop', function()
    local src = source;
    SetPlayerRoutingBucket(src, 0)
end)

RegisterServerEvent('rob_houses:giveItem')
AddEventHandler('rob_houses:giveItem', function(int, cat)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local random = math.random(1, #Config['rob_houses'].interieurs[int].items[cat])
    local qte = math.random(1,2)
    local item = Config['rob_houses'].interieurs[int].items[cat][random];
    local itemLabel = Framework.ITEMS:GetItemLabel(item)
    if itemLabel ~= nil then
        if xPlayer['inventory'].canCarryItem(item, qte) then
            xPlayer['inventory'].addInventoryItem(item, qte)
            xPlayer.showNotification("Vous avez trouver ~b~"..qte.."x~s~ ~g~"..itemLabel.."~s~ !")
        else
            xPlayer.showNotification("~r~Vous n'avez pas asser de place sur vous !~s~")
        end
    else
        print("^1 Errreur rob_houses: Item Invalide:^0 "..item)
    end
end)

-- Framework.RegisterCommand('addcambubg', { 'owner' }, function(xPlayer, args, showError)
--     local plyPed = GetPlayerPed(args.playerId.source)
--     local coords = GetEntityCoords(plyPed)
--     local math = function(value)
--         return Framework.Math.Round(value, 1)
--     end
--     print("{ robbed = false, int = 'h_gamme', job = 'police', pos = vector3("..math(coords.x)..", "..math(coords.y)..", "..math(coords.z)..") },")
-- end, true, {help = "Obtenir les Coordonnées d'un joueur", validate = true, arguments = {
-- 	{name = 'playerId', help = "ID du Joueur", type = 'player'}
-- }})