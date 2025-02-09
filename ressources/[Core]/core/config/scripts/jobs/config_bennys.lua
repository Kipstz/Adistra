Config['job_bennys'] = {
    Points = {
        vestiaire = {
            pos = vector3(-194.7, -1338.3, 31.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                BennysJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(-197.4, -1308.3, 31.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                BennysJob.OpenGarageMenu()
            end
        },
        harvest = {
            pos = vector3(-228.0, -1316.1, 31.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au stock",

            action = function()
                BennysJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(-206.5, -1336.3, 31.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'établi",

            action = function()
                BennysJob.OpenCraftMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-185.5, -1303.5, 31.3),
            },

            msg = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre Véhicule",

            action = function()
                local plyPed = PlayerPedId()
                local inVeh = IsPedInAnyVehicle(plyPed)

                if inVeh then
                    local vehicle = GetVehiclePedIsIn(plyPed)

                    Framework.Game.DeleteVehicle(vehicle)
                else
                    Framework.ShowNotification("~r~Vous devez être dans un Véhicule !")
                end
            end
        },
        boss = {
            pos = vector3(-196.1, -1315.2, 31.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'bennys')
            end
        }
    },

    Tenues = {
        { label = "Mécano", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 178,
                ['torso_2']  = 0,
                ['arms']     = 33,
                ['pants_1']  = 151,
                ['pants_2']  = 0,
                ['shoes_1']  = 128,
                ['shoes_2']  = 0,
            },
            f = {
                ['tshirt_1'] = 26,
                ['tshirt_2'] = 0,
                ['torso_1']  = 172,
                ['torso_2']  = 0,
                ['arms']     = 62,
                ['pants_1']  = 151,
                ['pants_2']  = 0,
                ['shoes_1']  = 85,
                ['shoes_2']  = 0,
            }
        }}
    },

    Sacs = {
        { label = "Sac N°1", skin = {
            m = {
                ['bags_1'] = 75,
                ['bags_2'] = 0
            }, 
            f = {
                ['bags_1'] = 71,
                ['bags_2'] = 0
            }, 
        }},
    },

    Garage = {
        SpawnPos = vector3(-185.5, -1303.5, 31.3),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules Benny's" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'towtruck', label = "Dépanneuse"},
            { categorie = 'base', minGrade = 0, model = 'towtruck2', label = "Dépanneuse 2"},
            { categorie = 'base', minGrade = 0, model = 'flatbed', label = "Plateau"},

        }
    },

    itemsHarvest = {
        { name = 'fixtool', label = "Outils de réparation", price = 1500, msg = "Récupération d'outils de réparation" },
        { name = 'carotool', label = "Outils de carrosserie", price = 1000, msg = "Récupération d'outils de carrosserie" },
        { name = 'gazbottle', label = "Bouteille de gaz", price = 500, msg = "Récupération de bouteille de gaz" },
    },
    itemsCraft = {
        { need = 'fixtool', name = 'fixkit', label = "Kit de Réparation", msg = "Fabrication d'un Kit de Réparation" },
        { need = 'carotool', name = 'carokit', label = "Kit de Carrosserie", msg = "Fabrication d'un Kit de Carrosserie" },
        { need = 'gazbottle', name = 'blowpipe', label = "Chalumeau", msg = "Fabrication d'un Chalumeau" },
    },
}