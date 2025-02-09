
Vip = {}

Framework.RegisterServerCallback("vip:getVip", function(src, cb) cb(Vip:getVip(src)) end)

RegisterNetEvent('vip:recupBonusMoney')
AddEventHandler('vip:recupBonusMoney', function(vip)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if Vip:isVip(src) then
        if vip.dateMoney == nil or vip.dateMoney ~= os.date("%d-%m-%Y") then
            xPlayer['accounts'].addMoney(Config['vip'].bonusMoney)
            Vip:updateDateMoneyBonus(xPlayer.identifier)
            xPlayer.showNotification("Vous avez récupérer votre bonus de ~g~"..Config['vip'].bonusMoney.."$~s~ !")
            xPlayer.triggerEvent('vip:recupBonusMoney', true)
        else
            xPlayer.showNotification("~r~Vous avez déjà récuperer votre Bonus !~s~")
            xPlayer.triggerEvent('vip:recupBonusMoney', true)
        end
    end
end)

RegisterNetEvent('vip:recupBonusCoins')
AddEventHandler('vip:recupBonusCoins', function(vip)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if Vip:isVip(src) then
        if Vip:wlLevel(vip, 'coins') then
            if vip.dateCoins == nil or vip.dateCoins ~= os.date("%d-%m-%Y") then
                xPlayer.addCoins(Config['vip'].bonusCoins)
                Vip:updateDateCoinsBonus(xPlayer.identifier)
                xPlayer.showNotification("Vous avez récupérer votre bonus de ~g~"..Config['vip'].bonusCoins.."Coins~s~ !")
                xPlayer.triggerEvent('vip:recupBonusCoins', true)
            else
                xPlayer.showNotification("~r~Vous avez déjà récuperer votre Bonus !~s~")
                xPlayer.triggerEvent('vip:recupBonusCoins', true)
            end
        end
    end
end)

RegisterNetEvent('vip:setTint')
AddEventHandler('vip:setTint', function(weaponName, tintIndex)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if Vip:isVip(src) then
        xPlayer['loadout'].setWeaponTint(weaponName, tintIndex)
    end
end)

RegisterNetEvent('vip:equipComponent')
AddEventHandler('vip:equipComponent', function(weaponName, componentName)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if Vip:isVip(src) then
        if xPlayer['loadout'].hasWeaponComponent(weaponName, componentName) then
            xPlayer['loadout'].removeWeaponComponent(weaponName, componentName)
        else
            xPlayer['loadout'].addWeaponComponent(weaponName, componentName)
        end
    end
end)

local playersRepairCount = {}

Framework.RegisterServerCallback('vip:canRepair', function(src, cb) 
    if playersRepairCount[src] ~= nil then 
        if playersRepairCount[src] > Config['vip'].repairCountLimit then
            cb(false)
            return
        else
            cb(true)
            playersRepairCount[src] = tonumber(playersRepairCount[src] + 1);
            return
        end
    else
        cb(true)
        playersRepairCount[src] = 1;
        return
    end
end)

Framework.RegisterCommand('addvip', { 'owner' }, function(xPlayer, args, showError)
    if not xPlayer then
        if args.month < 13 then
            for k,v in pairs(Config['vip'].levels) do
                if tonumber(args.level) == k then
                    if args.month == 0 then
                        Vip:addVip(args.playerId.source, args.level, true)
                        exports['Logs']:createLog({EmbedMessage = ("ADDVIP NIVEAU **%s** LIFETIME à **%s**"):format(args.level, args.playerId.getName()), player_id = args.playerId.source, channel = 'adminCommands'})
                        return
                    else
                        Vip:addVip(args.playerId.source, args.level)
                        exports['Logs']:createLog({EmbedMessage = ("ADDVIP NIVEAU **%s** à **%s**"):format(args.level, args.playerId.getName()), player_id = args.playerId.source, channel = 'adminCommands'})
                        return
                    end
                end
            end
            print("^1Niveau du VIP Invalide !^0")
        else
            print("^1Nombre de Mois Invalide !^0")
            return
        end
    else
        xPlayer.showNotification("~r~Cette commande ne peut être exécuter uniquement depuis la console !")
    end
end, true, {help = "Ajouter un VIP", validate = true, arguments = {
	{name = 'playerId', help = "ID du Joueur", type = 'player'},
    {name = 'level', help = "Niveau du VIP (1,2 ou 3)", type = 'number'},
    {name = 'month', help = "Temps du VIP (en mois)", type = 'number'},
}})

Framework.RegisterCommand('removevip', { 'owner' }, function(xPlayer, args, showError)
    if not xPlayer then
        Vip:removeVip(args.playerId.source)
        exports['Logs']:createLog({EmbedMessage = ("REMOVEVIP à:"):format(args.level, args.playerId.getName()), player_id = args.playerId.source, channel = 'adminCommands'})
    else
        xPlayer.showNotification("~r~Cette commande ne peut être exécuter uniquement depuis la console !")
    end
end, true, {help = "Retirer un VIP", validate = true, arguments = {
	{name = 'playerId', help = "ID du Joueur", type = 'player'}
}})