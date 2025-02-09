Config['ascenseurs'] = {
    { -- LSPD
        canTakesPos = {
            vector3(-407.2, -345.3, 38.4),
            vector3(-407.1, -348.3, 43.5),
            vector3(-406.3, -345.7, 48.5),
            vector3(-407.5, -348.2, 53.2),
        },
        etages = {
            { name = 'etage1', label = "Étage 1 (LSPD)", tpCoords = vector3(-407.2, -345.3, 38.4) },
            { name = 'etage1', label = "Étage 2 (SWAT)", tpCoords = vector3(-407.1, -348.3, 43.5) },
            { name = 'etage1', label = "Étage 3 (LSPD)", tpCoords = vector3(-406.3, -345.7, 48.5) },
            { name = 'etage1', label = "Étage 4 (FIB)", tpCoords = vector3(-407.5, -348.2, 53.2) },
        }
    },
    { -- EMS
        canTakesPos = {
            vector3(-794.5, -1245.7, 7.3),
            vector3(-773.5, -1207.2, 51.1),
        },
        etages = {
            { name = 'etage1', label = "Toit", tpCoords = vector3(-773.5, -1207.2, 51.1) },
            { name = 'etage1', label = "Rez de chaussée", tpCoords = vector3(-794.5, -1245.7, 7.3) },
        }
    },
    { -- Mine Entrer
        canTakesPos = {
            vector3(-596.8, 2090.4, 131.4),
        },
        etages = {
            { name = 'etage1', label = "Enter (Danger !)", tpCoords = vector3(-595.1, 2085.8, 131.3) },
        }
    },
    { -- Mine Sortie
        canTakesPos = {
            vector3(-595.1, 2085.8, 131.3),
        },
        etages = {
            { name = 'etage1', label = "Sortir", tpCoords = vector3(-596.8, 2090.4, 131.4) },
        }
    },
    
    { -- Avocat
        canTakesPos = {
            vector3(-1001.4, -784.6, 16.3),
            vector3(-1017.7, -766.3, 76.5),
        },
        etages = {
            { name = 'etage1', label = "Toit", tpCoords = vector3(-1017.7, -766.3, 76.5) },
            { name = 'etage1', label = "Entrer", tpCoords = vector3(-1001.4, -784.6, 16.3) },
        }
    },
}