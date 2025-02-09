
Config['cayo_vda'] = {
    jobs = {
        'bmf'
    },

    localisations = {
        { pos = vector3(789.2, 3404.8, 57.8), },
    },

    list = {
        cats = {
            { name = 'pistols', label = "Pistolets" },
            { name = 'points', label = "Arme de points" },
            { name = 'pm', label = "PM" },
            { name = 'fusils', label = "Fusils" },
            { name = 'pompfusils', label = "Fusils à Pompe" },
        },

        weapons = {
            { cat = 'pistols', name = 'weapon_pistol_mk2', label = "Pistolet MK2", price = 100000 },
            { cat = 'pistols', name = 'weapon_machinepistol', label = "Tech9", price = 150000 },
            { cat = 'pistols', name = 'weapon_doubleaction', label = "Double Action", price = 200000 },
            { cat = 'pistols', name = 'weapon_snspistol', label = "SNS Pistol", price = 50000 },
            { cat = 'pistols', name = 'weapon_vintagepistol', label = "Pistolet Vintage", price = 100000 },
            { cat = 'pistols', name = 'weapon_flaregun', label = "Pistolet de Détresse", price = 15000 },
            { cat = 'pistols', name = 'weapon_pistol50', label = "Pistolet Cal.50", price = 170000 },
            
            { cat = 'points', name = 'weapon_dagger', label = "Dagger", price = 5000 },
            { cat = 'points', name = 'weapon_switchblade', label = "Switch Blade", price = 5000 },
            { cat = 'points', name = 'weapon_flare', label = "Fusée de Détresse", price = 5000 },
            { cat = 'points', name = 'weapon_molotov', label = "Molotov", price = 5000 },

            { cat = 'pm', name = 'weapon_smg_mk2', label = "Micro-SMG MK2", price = 1750000 },

            { cat = 'fusils', name = 'WEAPON_ASSAULTRIFLE', label = "Carabine d'Assault", price = 1500000 },
            { cat = 'fusils', name = 'WEAPON_ASSAULTRIFLE_MK2', label = "Carabine d'Assault MK2", price = 2000000 },
            { cat = 'fusils', name = 'weapon_combatpdw', label = "ADP de Combat", price = 900000 },
            { cat = 'fusils', name = 'weapon_gusenberg', label = "Gusenberg", price = 1750000 },
            { cat = 'fusils', name = 'weapon_specialcarbine', label = "Carabine Spécial", price = 2500000 },
            { cat = 'fusils', name = 'weapon_advancedrifle', label = "Fusil Amélioré", price = 1750000 },

            { cat = 'pompfusils', name = 'weapon_autoshotgun', label = "Fusil à Pompe Automatique", price = 1000000 },
            { cat = 'pompfusils', name = 'weapon_sawnoffshotgun', label = "Fusil à Pompe Canon Scié", price = 1200000 },
        }
    }
}