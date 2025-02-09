
RegisterNetEvent("vda:buyWeapon")
AddEventHandler("vda:buyWeapon", function(weapon)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['accounts'].getAccount('black_money').money >= weapon.price then
        if not xPlayer['loadout'].hasWeapon(weapon.name) then

            xPlayer['loadout'].addWeapon(weapon.name, 250)
            xPlayer['accounts'].removeAccountMoney('black_money', weapon.price)
    
            xPlayer.showNotification("Vous avez acheté une arme !")
        else
            xPlayer.showNotification("~r~Vous avez déjà cette arme !~s~")
        end
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !~s~")
    end
end)