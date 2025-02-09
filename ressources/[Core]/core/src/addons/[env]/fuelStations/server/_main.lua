RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
    local xPlayer = Framework.GetPlayerFromId(source)
    local amount = Framework.Math.Round(price)

    if price > 0 then
        xPlayer['accounts'].removeMoney(amount)
    end
end)

RegisterNetEvent("fuel:buyCan")
AddEventHandler("fuel:buyCan", function(price)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not xPlayer['loadout'].hasWeapon('WEAPON_PETROLCAN') then
        local amount = Framework.Math.Round(price)

        if price > 0 then
            xPlayer['accounts'].removeMoney(amount)
        end
    
        xPlayer['loadout'].addWeapon('WEAPON_PETROLCAN', 255)
    end
end)