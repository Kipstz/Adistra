
RegisterNetEvent("madrazo_vda:buyWeapon")
AddEventHandler("madrazo_vda:buyWeapon", function(weapon)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['accounts'].getMoney() >= weapon.price then
        if not xPlayer['loadout'].hasWeapon(weapon.name) then

            xPlayer['loadout'].addWeapon(weapon.name, 250)
            xPlayer['accounts'].removeMoney(weapon.price)
    
            xPlayer.showNotification("Vous avez acheté une arme !")
        else
            xPlayer.showNotification("~r~Vous avez déjà cette arme !~s~")
        end
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !~s~")
    end
end)

RegisterNetEvent("madrazo_vda:buyItem")
AddEventHandler("madrazo_vda:buyItem", function(item, qte)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local price = tonumber(item.price * qte)
    if xPlayer['accounts'].getAccount('black_money').money >= price then
        xPlayer['inventory'].addInventoryItem(item.name, qte)
        xPlayer['accounts'].removeAccountMoney('black_money', price)
        xPlayer.showNotification("Vous avez payé ~r~"..price.."$ ~s~!")
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !~s~")
    end
end)