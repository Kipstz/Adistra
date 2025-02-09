Config['cartelcayo_vda'] = {
    jobs = {
        'cartelcayo'
    },

    localisations = {
        { pos = vector3(5014.17, -5753.25, 28.91), },
    },

    list = {
        cats = {
            { name = 'pistols', label = "Pistolets" },
            { name = 'pm', label = "PM" },
            { name = 'fusils', label = "Fusils" },
            { name = 'pompfusils', label = "Fusils à Pompe" },
            { name = 'mitrailleuse', label = "Mitrailleuse" },
            { name = 'sniper', label = "Sniper" },
        },

        weapons = {
            { cat = 'pistols', name = 'weapon_revolver', label = "Pistolet Revolver", price = 1000000 },
            { cat = 'pistols', name = 'weapon_revolver_mk2', label = "Pistolet Revolver MK2", price = 2500000 },
            { cat = 'pistols', name = 'weapon_navyrevolver', label = "Pistolet Revolver Navy", price = 3500000 },

            { cat = 'pm', name = 'weapon_microsmg', label = "Micro-SMG", price = 2000000 },
            { cat = 'pm', name = 'weapon_minismg', label = "Mini-SMG", price = 1500000 },

            { cat = 'fusils', name = 'WEAPON_ASSAULTRIFLE', label = "Fusil d'assault", price = 1500000 },
            { cat = 'fusils', name = 'WEAPON_ASSAULTRIFLE_MK2', label = "Fusil d'assault MK2", price = 2000000 },

            { cat = 'pompfusils', name = 'weapon_assaultshotgun', label = "Fusil à Pompe de combat", price = 5000000 },
            { cat = 'pompfusils', name = 'weapon_bullpupshotgun', label = "Fusil à Pompe BullPup", price = 4000000 },
            { cat = 'pompfusils', name = 'weapon_heavyshotgun', label = "Fusil à Pompe lourd", price = 3500000 },

            { cat = 'sniper', name = 'weapon_heavysniper_mk2', label = "Sniper lourd mk2", price = 5000000 },
            { cat = 'sniper', name = 'weapon_heavysniper', label = "Sniper lourd", price = 4000000 },

            { cat = 'mitrailleuse', name = 'weapon_combatmg', label = "Mitrailleuse de combat", price = 4500000 },
            { cat = 'mitrailleuse', name = 'weapon_combatmg_mk2', label = "Mitrailleuse de combat mk2", price = 6000000 },

        }
    }
}