ESX = nil

TriggerEvent('framework:init', function(obj) ESX = obj end)

ESX.RegisterServerCallback('gunfight:isInZone', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if ZoneGF[xPlayer.getIdentifier()] and ZoneGF[xPlayer.getIdentifier()].inZone then
        cb(true)
        return
    end
    cb(false)
end)