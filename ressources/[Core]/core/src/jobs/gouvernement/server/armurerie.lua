
GouvernementJob.weaponsPrises = {}

RegisterNetEvent('GouvernementJob:AddWeapon')
AddEventHandler('GouvernementJob:AddWeapon', function(weaponName)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)

    if not xPlayer['loadout'].hasWeapon(weaponName) then
        xPlayer['loadout'].addWeapon(weaponName, 255)
        table.insert(GouvernementJob.weaponsPrises, weaponName)

        xPlayer.showNotification("Vous avez ~g~reçu~s~ une Arme !")
    else
        xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
    end
end)

RegisterNetEvent('GouvernementJob:AddAllWeapons')
AddEventHandler('GouvernementJob:AddAllWeapons', function(weapons)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)
    GouvernementJob.weaponsPrises = {}

    for k,v in pairs(weapons) do
        if not xPlayer['loadout'].hasWeapon(v) then
            xPlayer['loadout'].addWeapon(v, 255)
            table.insert(GouvernementJob.weaponsPrises, v)
        end
    end

    xPlayer.showNotification("Vous avez ~g~reçu~s~ toutes les armes disponible !")
end)

RegisterNetEvent('GouvernementJob:RemoveAllWeapons')
AddEventHandler('GouvernementJob:RemoveAllWeapons', function(weapons)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)

    for k,v in pairs(GouvernementJob.weaponsPrises) do
        if xPlayer['loadout'].hasWeapon(v) then
            xPlayer['loadout'].removeWeapon(v)
        end
    end

    Wait(500)
    GouvernementJob.weaponsPrises = {}

    xPlayer.showNotification("Vous ~g~déposé~s~ toutes vos armes !")
end)
