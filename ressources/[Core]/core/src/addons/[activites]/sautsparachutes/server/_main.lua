
RegisterNetEvent('sautsparachutes:giveParachute')
AddEventHandler('sautsparachutes:giveParachute', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local price = tonumber(Config['sautsparachutes'].price)
    local myMoney = tonumber(xPlayer['accounts'].getMoney())

    if not xPlayer['loadout'].hasWeapon('GADGET_PARACHUTE') then
        if myMoney >= price then
            xPlayer['accounts'].removeMoney(price)
            xPlayer['loadout'].addWeapon('GADGET_PARACHUTE', 1)
            xPlayer['loadout'].setWeaponTint('GADGET_PARACHUTE', 6)

            xPlayer.showNotification("Vous avez ~g~acheter~s~ un parachute !")
        else
            xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !~s~")
        end
    else
        xPlayer.showNotification("~r~Vous avez déjà un parachute !~s~")
    end
end)