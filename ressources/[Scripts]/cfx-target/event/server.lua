TriggerEvent('framework:init', function(obj) Framework = obj end)

function IsAllowed(src)
    local xPlayer = Framework.GetPlayerFromId(src)
    local allowed = false;
    for k,v in pairs(staff_licence) do
        if v == xPlayer.identifier then
            allowed = true;
        end
    end
    return allowed;
end

RegisterNetEvent('contextmenu:checkLicence')
AddEventHandler('contextmenu:checkLicence', function()
    src = source
    myLicence = GetPlayerIdentifiers(src)[1]
    TriggerClientEvent('contextmenu:checkLicence:send', src, myLicence)
end)

Framework.RegisterServerCallback('contextmenu:isWL', function(src, cb)
    cb(Framework.IsPlayerAdmin(src))
end)

RegisterServerEvent('contextmenu:NetworkOverrideClockTime')
AddEventHandler('contextmenu:NetworkOverrideClockTime', function(time)
    local src = source
    if IsAllowed(src) then
        TriggerClientEvent('contextmenu:NetworkOverrideClockTime_response', -1, time)
    end
end)

RegisterServerEvent('contextmenu:SetWeatherType')
AddEventHandler('contextmenu:SetWeatherType', function(weather)
    local src = source
    if IsAllowed(src) then
        TriggerClientEvent('contextmenu:SetWeatherType_response', -1, weather)
    end
end) 
