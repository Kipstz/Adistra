Config['job_burger'] = {
    Points = {
        vestiaire = {
            pos = vector3(-1180.0, -893.1, 13.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                BurgerShotJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(-1179.3, -890.3, 13.8),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                BurgerShotJob.OpenGarageMenu()
            end
        },
        harvest = {
            pos = vector3(-1192.4, -898.7, 13.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au stock",

            action = function()
                BurgerShotJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(-1188.2, -899.1, 13.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à Aux Fournos",

            action = function()
                BurgerShotJob.OpenCraftMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-1177.8, -883.4, 13.8),
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
            pos = vector3(-1198.1, -897.5, 13.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'burger')
            end
        }
    },

    Tenues = {
        { label = "Cuisinier", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 598,
                ['torso_2']  = 0,
                ['arms']     = 18,
                ['pants_1']  = 50,
                ['pants_2']  = 0,
                ['shoes_1']  = 45,
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
                ['bags_1'] = 0,
                ['bags_2'] = 0
            }, 
            f = {
                ['bags_1'] = 71,
                ['bags_2'] = 0
            }, 
        }},
    },

    Garage = {
        SpawnPos = vector3(-1177.8, -883.4, 13.8),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'stalion2', label = "Stalion"},

        }
    },

    itemsHarvest = {
        { name = 'patate', label = "Pomme De Terre", price = 5, msg = "Récupération De Patate . . ." },
        { name = 'steak_crue', label = "Steak Crue", price = 7, msg = "Récupération De Steak Crue . . ." },
        { name = 'pain_crue', label = "Pain Crue", price = 15, msg = "Récupération De Pain Crue . . ." },
        { name = 'coca', label = "Coca Cola", price = 15, msg = "Récupération De Pain Crue . . ." },
    },
    itemsCraft = {
        { need = 'patate', name = 'frites', label = "Frites", msg = "Cuisson Des Frites . . ." },
        { need = 'steak_crue', name = 'steak_cuit', label = "Steak 180", msg = "Cuisson Du Steak . . ." },
        { need = 'pain_crue', name = 'pain_cuit', label = "Pain Toasté", msg = "Tastation Du Pain . . ." },
        { need = 'pain_cuit', 'steak_cuit', name = 'burger', label = "Burger", msg = "Construction Du Burger . . ." },
    },
}