RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
    StartVerif(source)
end)

local WeaponsList = {
    { name = 'WEAPON_DAGGER', hash = GetHashKey('WEAPON_DAGGER') },
    { name = 'WEAPON_BAT', hash = GetHashKey('WEAPON_BAT') },
    { name = 'WEAPON_BATTLEAXE', hash = GetHashKey('WEAPON_BATTLEAXE') },
    { name = 'WEAPON_KNUCKLE', hash = GetHashKey('WEAPON_KNUCKLE') },
    { name = 'WEAPON_BOTTLE', hash = GetHashKey('WEAPON_BOTTLE') },
    { name = 'WEAPON_CROWBAR', hash = GetHashKey('WEAPON_CROWBAR') },
    { name = 'WEAPON_FLASHLIGHT', hash = GetHashKey('WEAPON_FLASHLIGHT') },
    { name = 'WEAPON_GOLFCLUB', hash = GetHashKey('WEAPON_GOLFCLUB') },
    { name = 'WEAPON_HAMMER', hash = GetHashKey('WEAPON_HAMMER') },
    { name = 'WEAPON_HATCHET', hash = GetHashKey('WEAPON_HATCHET') },
    { name = 'WEAPON_KNIFE', hash = GetHashKey('WEAPON_KNIFE') },
    { name = 'WEAPON_MACHETE', hash = GetHashKey('WEAPON_MACHETE') },
    { name = 'WEAPON_NIGHTSTICK', hash = GetHashKey('WEAPON_NIGHTSTICK') },
    { name = 'WEAPON_WRENCH', hash = GetHashKey('WEAPON_WRENCH') },
    { name = 'WEAPON_POOLCUE', hash = GetHashKey('WEAPON_POOLCUE') },
    { name = 'WEAPON_STONE_HATCHET', hash = GetHashKey('WEAPON_STONE_HATCHET') },
    { name = 'WEAPON_SWITCHBLADE', hash = GetHashKey('WEAPON_SWITCHBLADE') },
    
    { name = 'WEAPON_APPISTOL', hash = GetHashKey('WEAPON_APPISTOL') },
    { name = 'WEAPON_CERAMICPISTOL', hash = GetHashKey('WEAPON_CERAMICPISTOL') },
    { name = 'WEAPON_COMBATPISTOL', hash = GetHashKey('WEAPON_COMBATPISTOL') },
    { name = 'WEAPON_DOUBLEACTION', hash = GetHashKey('WEAPON_DOUBLEACTION') },
    { name = 'WEAPON_NAVYREVOLVER', hash = GetHashKey('WEAPON_NAVYREVOLVER') },
    { name = 'WEAPON_FLAREGUN', hash = GetHashKey('WEAPON_FLAREGUN') },
    { name = 'WEAPON_GADGETPISTOL', hash = GetHashKey('WEAPON_GADGETPISTOL') },
    { name = 'WEAPON_HEAVYPISTOL', hash = GetHashKey('WEAPON_HEAVYPISTOL') },
    { name = 'WEAPON_REVOLVER', hash = GetHashKey('WEAPON_REVOLVER') },
    { name = 'WEAPON_REVOLVER_MK2', hash = GetHashKey('WEAPON_REVOLVER_MK2') },
    { name = 'WEAPON_MARKSMANPISTOL', hash = GetHashKey('WEAPON_MARKSMANPISTOL') },
    { name = 'WEAPON_PISTOL', hash = GetHashKey('WEAPON_PISTOL') },
    { name = 'WEAPON_PISTOL_MK2', hash = GetHashKey('WEAPON_PISTOL_MK2') },
    { name = 'WEAPON_PISTOL50', hash = GetHashKey('WEAPON_PISTOL50') },
    { name = 'WEAPON_SNSPISTOL', hash = GetHashKey('WEAPON_SNSPISTOL') },
    { name = 'WEAPON_SNSPISTOL_MK2', hash = GetHashKey('WEAPON_SNSPISTOL_MK2') },
    { name = 'WEAPON_STUNGUN', hash = GetHashKey('WEAPON_STUNGUN') },
    { name = 'WEAPON_RAYPISTOL', hash = GetHashKey('WEAPON_RAYPISTOL') },
    { name = 'WEAPON_VINTAGEPISTOL', hash = GetHashKey('WEAPON_VINTAGEPISTOL') },

    { name = 'WEAPON_ASSAULTSHOTGUN', hash = GetHashKey('WEAPON_ASSAULTSHOTGUN') },
    { name = 'WEAPON_AUTOSHOTGUN', hash = GetHashKey('WEAPON_AUTOSHOTGUN') },
    { name = 'WEAPON_BULLPUPSHOTGUN', hash = GetHashKey('WEAPON_BULLPUPSHOTGUN') },
    { name = 'WEAPON_COMBATSHOTGUN', hash = GetHashKey('WEAPON_COMBATSHOTGUN') },
    { name = 'WEAPON_DBSHOTGUN', hash = GetHashKey('WEAPON_DBSHOTGUN') },
    { name = 'WEAPON_HEAVYSHOTGUN', hash = GetHashKey('WEAPON_HEAVYSHOTGUN') },
    { name = 'WEAPON_MUSKET', hash = GetHashKey('WEAPON_MUSKET') },
    { name = 'WEAPON_PUMPSHOTGUN', hash = GetHashKey('WEAPON_PUMPSHOTGUN') },
    { name = 'WEAPON_PUMPSHOTGUN_MK2', hash = GetHashKey('WEAPON_PUMPSHOTGUN_MK2') },
    { name = 'WEAPON_SAWNOFFSHOTGUN', hash = GetHashKey('WEAPON_SAWNOFFSHOTGUN') },

    { name = 'WEAPON_ASSAULTSMG', hash = GetHashKey('WEAPON_ASSAULTSMG') },
    { name = 'WEAPON_COMBATMG', hash = GetHashKey('WEAPON_COMBATMG') },
    { name = 'WEAPON_COMBATMG_MK2', hash = GetHashKey('WEAPON_COMBATMG_MK2') },
    { name = 'WEAPON_COMBATPDW', hash = GetHashKey('WEAPON_COMBATPDW') },
    { name = 'WEAPON_GUSENBERG', hash = GetHashKey('WEAPON_GUSENBERG') },
    { name = 'WEAPON_MACHINEPISTOL', hash = GetHashKey('WEAPON_MACHINEPISTOL') },
    { name = 'WEAPON_MG', hash = GetHashKey('WEAPON_MG') },
    { name = 'WEAPON_MICROSMG', hash = GetHashKey('WEAPON_MICROSMG') },
    { name = 'WEAPON_MINISMG', hash = GetHashKey('WEAPON_MINISMG') },
    { name = 'WEAPON_SMG', hash = GetHashKey('WEAPON_SMG') },
    { name = 'WEAPON_SMG_MK2', hash = GetHashKey('WEAPON_SMG_MK2') },
    { name = 'WEAPON_RAYCARBINE', hash = GetHashKey('WEAPON_RAYCARBINE') },

    { name = 'WEAPON_ADVANCEDRIFLE', hash = GetHashKey('WEAPON_ADVANCEDRIFLE') },
    { name = 'WEAPON_ASSAULTRIFLE', hash = GetHashKey('WEAPON_ASSAULTRIFLE') },
    { name = 'WEAPON_ASSAULTRIFLE_MK2', hash = GetHashKey('WEAPON_ASSAULTRIFLE_MK2') },
    { name = 'WEAPON_BULLPUPRIFLE', hash = GetHashKey('WEAPON_BULLPUPRIFLE') },
    { name = 'WEAPON_BULLPUPRIFLE_MK2', hash = GetHashKey('WEAPON_BULLPUPRIFLE_MK2') },
    { name = 'WEAPON_CARBINERIFLE', hash = GetHashKey('WEAPON_CARBINERIFLE') },
    { name = 'WEAPON_CARBINERIFLE_MK2', hash = GetHashKey('WEAPON_CARBINERIFLE_MK2') },
    { name = 'WEAPON_COMPACTRIFLE', hash = GetHashKey('WEAPON_COMPACTRIFLE') },
    { name = 'WEAPON_MILITARYRIFLE', hash = GetHashKey('WEAPON_MILITARYRIFLE') },
    { name = 'WEAPON_SPECIALCARBINE', hash = GetHashKey('WEAPON_SPECIALCARBINE') },
    { name = 'WEAPON_SPECIALCARBINE_MK2', hash = GetHashKey('WEAPON_SPECIALCARBINE_MK2') },

    { name = 'WEAPON_HEAVYSNIPER', hash = GetHashKey('WEAPON_HEAVYSNIPER') },
    { name = 'WEAPON_HEAVYSNIPER_MK2', hash = GetHashKey('WEAPON_HEAVYSNIPER_MK2') },
    { name = 'WEAPON_MARKSMANRIFLE', hash = GetHashKey('WEAPON_MARKSMANRIFLE') },
    { name = 'WEAPON_MARKSMANRIFLE_MK2', hash = GetHashKey('WEAPON_MARKSMANRIFLE_MK2') },
    { name = 'WEAPON_SNIPERRIFLE', hash = GetHashKey('WEAPON_SNIPERRIFLE') },

    { name = 'WEAPON_COMPACTLAUNCHER', hash = GetHashKey('WEAPON_COMPACTLAUNCHER') },
    { name = 'WEAPON_FIREWORK', hash = GetHashKey('WEAPON_FIREWORK') },
    { name = 'WEAPON_GRENADELAUNCHER', hash = GetHashKey('WEAPON_GRENADELAUNCHER') },
    { name = 'WEAPON_HOMINGLAUNCHER', hash = GetHashKey('WEAPON_HOMINGLAUNCHER') },
    { name = 'WEAPON_MINIGUN', hash = GetHashKey('WEAPON_MINIGUN') },
    { name = 'WEAPON_RAILGUN', hash = GetHashKey('WEAPON_RAILGUN') },
    { name = 'WEAPON_RPG', hash = GetHashKey('WEAPON_RPG') },
    { name = 'WEAPON_RAYMINIGUN', hash = GetHashKey('WEAPON_RAYMINIGUN') },

    { name = 'WEAPON_BALL', hash = GetHashKey('WEAPON_BALL') },
    { name = 'WEAPON_BZGAS', hash = GetHashKey('WEAPON_BZGAS') },
    { name = 'WEAPON_FLARE', hash = GetHashKey('WEAPON_FLARE') },
    { name = 'WEAPON_GRENADE', hash = GetHashKey('WEAPON_GRENADE') },
    { name = 'WEAPON_PETROLCAN', hash = GetHashKey('WEAPON_PETROLCAN') },
    { name = 'WEAPON_HAZARDCAN', hash = GetHashKey('WEAPON_HAZARDCAN') },
    { name = 'WEAPON_MOLOTOV', hash = GetHashKey('WEAPON_MOLOTOV') },
    { name = 'WEAPON_PROXMINE', hash = GetHashKey('WEAPON_PROXMINE') },
    { name = 'WEAPON_PIPEBOMB', hash = GetHashKey('WEAPON_PIPEBOMB') },
    { name = 'WEAPON_SNOWBALL', hash = GetHashKey('WEAPON_SNOWBALL') },
    { name = 'WEAPON_STICKYBOMB', hash = GetHashKey('WEAPON_STICKYBOMB') },
    { name = 'WEAPON_SMOKEGRENADE', hash = GetHashKey('WEAPON_SMOKEGRENADE') },

    { name = 'WEAPON_FIREEXTINGUISHER', hash = GetHashKey('WEAPON_FIREEXTINGUISHER') },
    { name = 'WEAPON_DIGISCANNER', hash = GetHashKey('WEAPON_DIGISCANNER') },
    { name = 'GADGET_PARACHUTE', hash = GetHashKey('GADGET_PARACHUTE') },

    { name = 'WEAPON_JOSAK1', hash = GetHashKey('WEAPON_JOSAK1') },
    { name = 'WEAPON_CARBINERIFLE2', hash = GetHashKey('WEAPON_CARBINERIFLE2') },
    { name = 'WEAPON_CARBINERIFLE3', hash = GetHashKey('WEAPON_CARBINERIFLE3') },
    { name = 'WEAPON_CARBINERIFLE4', hash = GetHashKey('WEAPON_CARBINERIFLE4') },
    { name = 'WEAPON_MICROSMG2', hash = GetHashKey('WEAPON_MICROSMG2') },
    { name = 'WEAPON_MARKSMANRIFLE2', hash = GetHashKey('WEAPON_MARKSMANRIFLE2') },
    { name = 'WEAPON_MARKSMANRIFLE3', hash = GetHashKey('WEAPON_MARKSMANRIFLE3') },
    { name = 'WEAPON_PISTOL2', hash = GetHashKey('WEAPON_PISTOL2') },
}

function StartVerif(src)
    local unarmedHash = `WEAPON_UNARMED`;
    local currWeapon = unarmedHash;

    CreateThread(function()
        while true do
            wait = 7500;

            local ped = GetPlayerPed(src)
            local newWeap = GetSelectedPedWeapon(ped)

            if newWeap ~= currWeapon then
                currWeapon = newWeap;
                local xPlayer = Framework.GetPlayerFromId(src)

                for k,v in pairs(WeaponsList) do
                    if v.name ~= "WEAPON_SNOWBALL" then
                        if v.hash == newWeap then
                            if not (xPlayer['loadout'].hasWeapon(string.upper(v.name)) or xPlayer['loadout'].hasWeapon(string.lower(v.name))) then
                                RemoveWeaponFromPed(ped, newWeap)
        
                                exports["ac"]:fg_BanPlayer(
                                    src,
                                    "Anti Give Weapon",
                                   true
                                )
                            end
                        end
                    end
                end
            end
            Wait(wait)
        end
    end)
end