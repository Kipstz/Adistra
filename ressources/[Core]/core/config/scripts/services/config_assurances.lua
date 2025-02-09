Config['assurances'] = {
    MenuTitle = {
        AssuranceMenu = "Assurances",
        SelectedMenu = "Assurances",
        newContratMenu = "Assurances"
    },
    MenuSubTitle = {
        AssuranceMenu = "Vos véhicules:",
        SelectedMenu = "Véhicule:",
        newContratMenu = "Séléctionner un Contrat"
    },

    localisations = {
        { pos = vector3(-837.6, -274.5, 38.9), type = 'car', spawn = { coords = vector3(-859.1, -260.6, 39.6), heading = 145.0 } },
        { pos = vector3(1430.9, 3616.6, 34.9), type = 'car', spawn = { coords = vector3(1422.6, 3614.2, 34.9), heading = 145.0 } },
        { pos = vector3(-143.4, 6306.2, 31.6), type = 'car', spawn = { coords = vector3(-146.2, 6313.4, 31.4), heading = 145.0 } },
        { pos = vector3(4414.7, -4493.7, 4.2), type = 'car', spawn = { coords = vector3(4445.5, -4492.9, 4.2), heading = 145.0 } }, -- Cayo Perico

        { pos = vector3(-753.7, -1510.2, 5.0), type = 'boat', spawn = { coords = vector3(-808.5, -1506.3, -0.5), heading = 145.0 } },

        { pos = vector3(-1071.2, -2870.0, 13.9), type = 'aircraft', spawn = { coords = vector3(-1112.1, -2883.2, 13.9), heading = 145.0 } },
    },

    contrats = {
        ['basique'] = {
            name = "Basique",
            price = 25,
            delay = 10*60000, -- exprimer en minutes
            franchise = 650,
            desc = "Prix de ~g~25$~s~ par jour, un temps d'attente entre chaque véhicule demander de ~b~10 minutes~s~ et une franchise de ~g~650$~s~"
        },
        ['avance'] = {
            name = "Avancé",
            price = 50,
            delay = 5*60000, -- exprimer en minutes
            franchise = 500,
            desc = "Prix de ~g~50$~s~ par jour, un temps d'attente entre chaque véhicule demander de ~b~5 minutes~s~ et une franchise de ~g~500$~s~"
        },
        ['premium'] = {
            name = "Premium",
            price = 75,
            delay = 2*60000, -- exprimer en minutes
            franchise = 250,
            desc = "Prix de ~g~75$~s~ par jour, un temps d'attente entre chaque véhicule demander de ~b~2 minutes~s~ et une franchise de ~g~250$~s~"
        }
    }
}