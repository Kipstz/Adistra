RegisterServerEvent('framework:onPlayerDeath')
AddEventHandler('framework:onPlayerDeath', function(data)
    data.victim = source

    if not data.killedByPlayer then
        data.killedByPlayer = source
    end

    local xPlayer = ESX.GetPlayerFromId(data.victim)
    local xTarget = ESX.GetPlayerFromId(data.killerServerId)

    if(ZoneGF[xPlayer.getIdentifier()] and ZoneGF[xPlayer.getIdentifier()].inZone and not xTarget) then
        TriggerClientEvent('Yvelt:revivePlayerGF', data.victim)
        Wait(10)
        TriggerClientEvent("AmbulanceJob:revive",  data.victim)
        return
    end
    
    if ZoneGF[xPlayer.getIdentifier()] and ZoneGF[xPlayer.getIdentifier()].inZone and ZoneGF[xTarget.getIdentifier()] and ZoneGF[xTarget.getIdentifier()].inZone then
        if data.victim ~= data.killedByPlayer then
            local victimName = GetPlayerName(data.killerServerId)
            local targetName = GetPlayerName(data.victim)

            TriggerClientEvent('framework:showNotification', data.victim, translations.deathNotification:format(victimName))
            ZoneGF[xPlayer.getIdentifier()].mort = ZoneGF[xPlayer.getIdentifier()].mort + 1
            ZoneGF[xPlayer.getIdentifier()].kd = ZoneGF[xPlayer.getIdentifier()].kill / ZoneGF[xPlayer.getIdentifier()].mort

            TriggerClientEvent('framework:showNotification', data.killerServerId, translations.killNotification:format(targetName))
            TriggerClientEvent('framework:showNotification', data.killerServerId, '~g~' .. translations.rewardNotification:format(YveltConfigGF.zoneGF.reward))
            
            ZoneGF[xTarget.getIdentifier()].kill = ZoneGF[xTarget.getIdentifier()].kill + 1
            ZoneGF[xTarget.getIdentifier()].kd = ZoneGF[xTarget.getIdentifier()].kill / ZoneGF[xTarget.getIdentifier()].mort
        
            xTarget['accounts'].addMoney(YveltConfigGF.zoneGF.reward)
        end
        
        Wait(YveltConfigGF.zoneGF.respawnTime)

        TriggerClientEvent('Yvelt:revivePlayerGF', data.victim)
        Wait(10) -- Dont touch this
        TriggerClientEvent("AmbulanceJob:revive",  data.victim)
    end
end)
