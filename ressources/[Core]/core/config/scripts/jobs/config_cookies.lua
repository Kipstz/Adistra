Config['job_cookies'] = {
    Points = {
        vestiaire = {
            pos = vector3(-1180.0, -893.1, 13.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                CookiesJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(-533.7, 27.9, 44.5),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                CookiesJob.OpenGarageMenu()
            end
        },
        harvest = {
            pos = vector3(-519.1, 46.1, 44.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au stock",

            action = function()
                CookiesJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(-523.2, 40.0, 44.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à Aux Fournos",

            action = function()
                CookiesJob.OpenCraftMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-508.6, 21.0, 44.5),
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
            pos = vector3(-528.1, 49.8, 44.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'cookies')
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
        SpawnPos = vector3(-508.6, 21.0, 44.5),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'slamvan', label = "Slamvan"},

        }
    },

    itemsHarvest = {
        { name = 'pate', label = "Pate A Cookies", price = 5, price = 10, msg = "Récupération De La Pate A Cookies . . ." },
        { name = 'adiscook', label = "Ingredients AdisCook", price = 5, price = 10, msg = "Récupération Des Ingredients AdisCook . . ." },
        { name = 'pepite_coco', label = "Pépite De Chocolat", price = 8, msg = "Récupération Des Pépite De Chocolat . . ." },
        { name = 'caramel', label = "Caramel", price = 15, msg = "Récupération Du Caramel . . ." },
    },
    itemsCraft = {
        { need = 'pate', 'pepite_coco', name = 'cookies_choco', label = "Cookie Chocolat", msg = "Construction Du Cookie Au Chocolat . . ." },
        { need = 'pate', 'pepite_coco', 'caramel', name = 'cookies_choco_caramel', label = "Cookie Chocolat Caramel", msg = "Construction Du Cookie Au Chocolat Caramel . . ." },
        { need = 'pate', 'adiscook', name = 'cookies_adiscook', label = "Cookie AdisCook", msg = "Construction Du Cookie AdisCook . . ." },
        { need = 'pate', 'adiscook', 'caramel', name = 'cookies_adiscook_caramel', label = "Cookie AdisCook Caramel", msg = "Construction Du Cookie AdisCook Au Caramel . . ." },
    },
}