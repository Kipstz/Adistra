Config['job_mecano'] = {
    Points = {
        vestiaire = {
            pos = vector3(-342.76, -145.64, 39.06),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                MecanoJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(-360.92, -138.32, 38.68),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                MecanoJob.OpenGarageMenu()
            end
        },
        harvest = {
            pos = vector3(-335.17, -156.17, 39.06),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au stock",

            action = function()
                MecanoJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(-329.73, -161.57, 39.06),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'établi",

            action = function()
                MecanoJob.OpenCraftMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-358.37, -122.98, 38.72),
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
            pos = vector3(-341.51, -169.63, 39.06),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'mecano')
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
        SpawnPos = vector3(-364.4, -146.8, 38.2),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules LS Custom" },
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