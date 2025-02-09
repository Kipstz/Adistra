Config['cayo_vehicles_orga'] = {
    MenuTitle = {
        MainMenu = "Véhicules",
        CategoryMenu = "Véhicules"
    },
    MenuSubTitle = {
        MainMenu = "Choissisez une catégorie",
        CategoryMenu = "Choissisez un véhicule"
    },

    localisations = {
        { 
            pos = vector3(4983.9, -5706.5, 19.9),
            categories = {
                { name = 'car', label = "Voitures", spawn = vector3(4973.7, -5702.4, 19.9), heading = 42.0 },
                { name = 'bike', label = "Motos", spawn = vector3(4973.7, -5702.4, 19.9), heading = 42.0 },
                { name = 'aircraft', label = "Hélicos", spawn = vector3(4973.7, -5702.4, 19.9), heading = 42.0 },
                { name = 'boats', label = "Bateaux", spawn = vector3(5114.6, -5762.5, -0.1), heading = 190.0 },
            },
        }
    },

    localisation = {
        { 
            pos = vector3(4986.7, -5700.0, 19.8),
            categories = {
                { name = 'avions', label = "Avions", spawn = vector3(4414.0, -4523.8, 4.1), heading = 190.0 },
            },
        }
    },

    vehicles = {
        { cat = 'car', name = 'winky', label = "Winky" },
        { cat = 'car', name = 'squaddie', label = "Squaddie" },
        { cat = 'car', name = 'vetir', label = "Vetir" },
        { cat = 'car', name = 'technical2', label = "Technical 2" },
        { cat = 'car', name = 'technical3', label = "Technical 3" },

        { cat = 'bike', name = 'manchez2', label = "Manchez" },

        { cat = 'aircraft', name = 'frogger', label = "Frogger" },
        { cat = 'aircraft', name = 'buzzard2', label = "Buzzard" },

        { cat = 'avions', name = 'strikeforce', label = "Strikeforce"},
        { cat = 'avions', name = 'valkyrie', label = "Valkyrie"},
        { cat = 'avions', name = 'valkyrie2', label = "Valkyrie 2"},
        { cat = 'avions', name = 'cargobob', label = "Cargobob 1"},
        { cat = 'avions', name = 'cargobob2', label = "Cargobob 2"},
        { cat = 'avions', name = 'cargobob3', label = "Cargobob 3"},
        { cat = 'avions', name = 'cargobob4', label = "Cargobob 4"},
        { cat = 'avions', name = 'annihilator2', label = "Annihilator 2"},
        { cat = 'avions', name = 'skylift', label = "Skylift"},
        { cat = 'avions', name = 'hydra', label = "Hydra"},
        { cat = 'avions', name = 'lazer', label = "Lazer"},
        { cat = 'avions', name = 'bombushka', label = "Bombushka"},
        { cat = 'avions', name = 'besra', label = "Besra"},
        { cat = 'avions', name = 'avenger', label = "Avenger"},
        { cat = 'avions', name = 'titan', label = "Titan"},
        { cat = 'avions', name = 'tula', label = "Tula"},
        { cat = 'avions', name = 'miljet', label = "Miljet"},
        { cat = 'avions', name = 'molotok', label = "Molotok"},
        
        { cat = 'boats', name = 'patrolboat', label = "Bateau De Guerre"},

    },
    deleters = {
        pos = {
            vector3(4499.2, -4486.7, 4.2),
            vector3(4414.0, -4523.8, 4.1),
            vector3(5114.6, -5762.5, -0.1)
        },

        action = function()
            local plyPed = PlayerPedId()
            local inVeh = IsPedInAnyBoat(plyPed) or IsPedInAnyHeli(plyPed) or IsPedInAnyPlane(plyPed)

            if inVeh then
                local vehicle = GetVehiclePedIsIn(plyPed)

                Framework.Game.DeleteVehicle(vehicle)
            else
                Framework.ShowNotification("~r~Vous devez être dans un Véhicule !")
            end
        end
    },
}