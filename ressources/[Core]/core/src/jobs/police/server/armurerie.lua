
PoliceJob.weaponsPrises = {}

RegisterNetEvent('PoliceJob:AddWeapon')
AddEventHandler('PoliceJob:AddWeapon', function(weaponName)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)

    if not xPlayer['loadout'].hasWeapon(weaponName) then
        xPlayer['loadout'].addWeapon(weaponName, 255)
        table.insert(PoliceJob.weaponsPrises, weaponName)

        xPlayer.showNotification("Vous avez ~g~reçu~s~ une Arme !")
    else
        xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
    end
end)

RegisterNetEvent('PoliceJob:AddAllWeapons')
AddEventHandler('PoliceJob:AddAllWeapons', function(weapons)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)
    PoliceJob.weaponsPrises = {}

    for k,v in pairs(weapons) do
        if not xPlayer['loadout'].hasWeapon(v) then
            xPlayer['loadout'].addWeapon(v, 255)
            table.insert(PoliceJob.weaponsPrises, v)
        end
    end

    xPlayer.showNotification("Vous avez ~g~reçu~s~ toutes les armes disponible !")
end)

RegisterNetEvent('PoliceJob:RemoveAllWeapons')
AddEventHandler('PoliceJob:RemoveAllWeapons', function(weapons)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)

    for k,v in pairs(PoliceJob.weaponsPrises) do
        if xPlayer['loadout'].hasWeapon(v) then
            xPlayer['loadout'].removeWeapon(v)
        end
    end

    Wait(500)
    PoliceJob.weaponsPrises = {}

    xPlayer.showNotification("Vous ~g~déposé~s~ toutes vos armes !")
end)
