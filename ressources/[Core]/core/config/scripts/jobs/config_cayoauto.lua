Config['job_cayoauto'] = {
    Points = {
        vestiaire = {
            pos = vector3(4476.0, -4453.5, 4.2),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                CayoAutoJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(4479.2, -4461.9, 4.2),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                CayoAutoJob.OpenGarageMenu()
            end
        },
        harvest = {
            pos = vector3(4470.5, -4454.0, 4.2),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au stock",

            action = function()
                CayoAutoJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(4461.2, -4463.8, 4.9),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'établi",

            action = function()
                CayoAutoJob.OpenCraftMenu()
            end
        },
        deleters = {
            pos = {
                vector3(4480.8, -4469.0, 4.2),
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
            pos = vector3(4460.7, -4458.6, 4.9),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'cayoauto')
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
        SpawnPos = vector3(4480.8, -4469.0, 4.2),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules Automobile" },
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