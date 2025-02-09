
SheriffPaletoJob.weaponsPrises = {}

RegisterNetEvent('SheriffPaletoJob:AddWeapon')
AddEventHandler('SheriffPaletoJob:AddWeapon', function(weaponName)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)

    if not xPlayer['loadout'].hasWeapon(weaponName) then
        xPlayer['loadout'].addWeapon(weaponName, 255)
        table.insert(SheriffPaletoJob.weaponsPrises, weaponName)

        xPlayer.showNotification("Vous avez ~g~reçu~s~ une Arme !")
    else
        xPlayer.showNotification("~r~Vous avez déjà cette Arme !")
    end
end)

RegisterNetEvent('SheriffPaletoJob:AddAllWeapons')
AddEventHandler('SheriffPaletoJob:AddAllWeapons', function(weapons)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)
    SheriffPaletoJob.weaponsPrises = {}

    for k,v in pairs(weapons) do
        if not xPlayer['loadout'].hasWeapon(v) then
            xPlayer['loadout'].addWeapon(v, 255)
            table.insert(SheriffPaletoJob.weaponsPrises, v)
        end
    end

    xPlayer.showNotification("Vous avez ~g~reçu~s~ toutes les armes disponible !")
end)

RegisterNetEvent('SheriffPaletoJob:RemoveAllWeapons')
AddEventHandler('SheriffPaletoJob:RemoveAllWeapons', function(weapons)
    local source = source
    local xPlayer = Framework.GetPlayerFromId(source)

    for k,v in pairs(SheriffPaletoJob.weaponsPrises) do
        if xPlayer['loadout'].hasWeapon(v) then
            xPlayer['loadout'].removeWeapon(v)
        end
    end

    Wait(500)
    SheriffPaletoJob.weaponsPrises = {}

    xPlayer.showNotification("Vous ~g~déposé~s~ toutes vos armes !")
end)
