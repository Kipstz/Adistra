
RegisterNetEvent('shop_armurerie:buy')
AddEventHandler('shop_armurerie:buy', function(weapon)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = tonumber(xPlayer['accounts'].getMoney())
    local price = tonumber(weapon.price)
    local weaponLabel = Framework.GetWeaponLabel(weapon.name)

    if myMoney >= price then
        if not xPlayer['loadout'].hasWeapon(weapon.name) then
            xPlayer['loadout'].addWeapon(weapon.name, 150)
            xPlayer['accounts'].removeMoney(price)
            if weapon.name == 'GADGET_PARACHUTE' then xPlayer['loadout'].setWeaponTint('GADGET_PARACHUTE', 6) end
            xPlayer.showNotification("Vous avez acheter ~r~"..weaponLabel.."~s~ pour ~g~"..Framework.Math.GroupDigits(weapon.price).."$ ~s~!")
        else
            xPlayer.showNotification("~r~Vous avez déjà cette arme !")
        end
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterNetEvent('shop_armurerie:buyPPA')
AddEventHandler('shop_armurerie:buyPPA', function()
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = tonumber(xPlayer['accounts'].getMoney())
    local price = tonumber(Config['shop_armurerie'].pricePPA)

    if myMoney >= price then
        TriggerEvent('licenses:addLicense', source, 'weapon')
        xPlayer['accounts'].removeMoney(price)

        xPlayer.showNotification("Vous avez acheter le PPA pour ~g~"..Framework.Math.GroupDigits(price).."$ ~s~!")
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterNetEvent('shop_armurerie:buyChargeur')
AddEventHandler('shop_armurerie:buyChargeur', function(price, qte)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = tonumber(xPlayer['accounts'].getMoney())
    local price = tonumber(price*qte)
    local itemLabel = Framework.ITEMS:GetItemLabel(Config['shop_armurerie'].chargeurItem)

    if myMoney >= price then
        xPlayer['inventory'].addInventoryItem(Config['shop_armurerie'].chargeurItem, qte)
        xPlayer['accounts'].removeMoney(price)

        xPlayer.showNotification("Vous avez acheter ~b~"..qte.."x ~r~"..itemLabel.."~s~  pour ~g~"..Framework.Math.GroupDigits(price).."$ ~s~!")
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

RegisterNetEvent('shop_armurerie:buyGpb')
AddEventHandler('shop_armurerie:buyGpb', function(price, qte)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = tonumber(xPlayer['accounts'].getMoney())
    local price = tonumber(price*qte)
    local itemLabel = Framework.ITEMS:GetItemLabel(Config['shop_armurerie'].gbpItem)

    if myMoney >= price then
        xPlayer['inventory'].addInventoryItem(Config['shop_armurerie'].gbpItem, qte)
        xPlayer['accounts'].removeMoney(price)

        xPlayer.showNotification("Vous avez acheter ~b~"..qte.."x ~r~"..itemLabel.."~s~  pour ~g~"..Framework.Math.GroupDigits(price).."$ ~s~!")
    else
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)

Framework.RegisterServerCallback('shop_armurerie:checkLicense', function(source, cb)
    local result = false

    TriggerEvent("licenses:getLicenses", source, function(licenses)
        for k,v in pairs(licenses) do
            if v.type == "weapon" then
                result = true
            end
        end
    end)

    Wait(125)
    
    cb(result)
end)