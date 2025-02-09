Config['job_bahama'] = {
    Points = {
        vestiaire = {
            pos = vector3(-1377.3, -634.0, 30.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                BahamaJob.OpenVestiaireMenu()
            end
        },
        harvest = {
            pos = vector3(854.20, -2120.20, 30.60),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Fournisseur",

            action = function()
                BahamaJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(-1400.5, -601.8, 30.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Bar",

            action = function()
                BahamaJob.OpenCraftMenu()
            end
        },
        garage = {
            pos = vector3(-1383.0, -640.9, 28.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                BahamaJob.OpenGarageMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-1377.5, -645.7, 28.7),
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
            pos = vector3(-1370.5, -627.4, 30.4),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'bahama')
            end
        }
    },

    Tenues = {
        { label = "Barman", skin = {
            m = {
                ['tshirt_1'] = 132,
                ['tshirt_2'] = 0,
                ['torso_1']  = 406,
                ['torso_2']  = 0,
                ['arms']     = 40,
                ['pants_1']  = 134,
                ['pants_2']  = 0,
                ['shoes_1']  = 10,
                ['shoes_2']  = 0,
            },
            f = {
                ['tshirt_1'] = 151,
                ['tshirt_2'] = 2,
                ['torso_1']  = 451,
                ['torso_2']  = 0,
                ['arms']     = 62,
                ['pants_1']  = 149,
                ['pants_2']  = 0,
                ['shoes_1']  = 103,
                ['shoes_2']  = 2,
            }
        }},
        -- { label = "Videur", skin = {
        --     m = {
        --         ['tshirt_1'] = 15,
        --         ['tshirt_2'] = 0,
        --         ['torso_1']  = 474,
        --         ['torso_2']  = 0,
        --         ['arms']     = 19,
        --         ['pants_1']  = 28,
        --         ['pants_2']  = 0,
        --         ['shoes_1']  = 14,
        --         ['shoes_2']  = 0,
        --     },
        --     f = {
        --         ['tshirt_1'] = 36,
        --         ['tshirt_2'] = 0,
        --         ['torso_1']  = 540,
        --         ['torso_2']  = 0,
        --         ['arms']     = 1,
        --         ['pants_1']  = 133,
        --         ['pants_2']  = 0,
        --         ['shoes_1']  = 64,
        --         ['shoes_2']  = 0,
        --     }
        -- }},
        { label = "Danseur(euse)", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 364,
                ['torso_2']  = 0,
                ['arms']     = 156,
                ['pants_1']  = 173,
                ['pants_2']  = 1,
                ['shoes_1']  = 138,
                ['shoes_2']  = 0,
            },
            f = {
                ['tshirt_1'] = 52,
                ['tshirt_2'] = 1,
                ['torso_1']  = 105,
                ['torso_2']  = 0,
                ['arms']     = 23,
                ['pants_1']  = 94,
                ['pants_2']  = 1,
                ['shoes_1']  = 6,
                ['shoes_2']  = 0,
            }
        }},
    },

    Garage = {
        SpawnPos = vector3(-1377.5, -645.7, 28.7),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'mule3', label = "Mule"},
            { categorie = 'base', minGrade = 1, model = 'pbus2', label = "Bus Festival"},
        }
    },

    itemsHarvest = {
        { name = 'glacon', label = "Glaçon", price = 5},
        { name = 'citronvert', label = "Citron-Vert", price = 5 },
        { name = 'grenadine', label = "Grenadine", price = 5 },
        { name = 'menthe', label = "Menthe", price = 5 },
        { name = 'jusdefruit', label = "Jus de fruit", price = 5 },
        { name = 'coca', label = "Coca-Cola", price = 5 },
        { name = 'limonade', label = "Limonade", price = 5 },
        { name = 'biere', label = "Bière", price = 5 },
        { name = 'whisky', label = "Whisky", price = 5 },
        { name = 'vodka', label = "Vodka", price = 5 },
        { name = 'rhum', label = "Rhum", price = 5 },
        { name = 'rhumblanc', label = "Rhum Blanc", price = 5 },
        { name = 'gin', label = "Gin", price = 5 },
        { name = 'schweppes', label = "Schweppes", price = 5 },
        { name = 'crazytiger', label = "CrazyTiger", price = 5 },
        { name = 'ricard', label = "Ricard", price = 5 },
        { name = 'siropcanne', label = "Sirop de Sucre de Canne", price = 5 },
    },
    itemsCraft = {
        { needs = {'whisky', 'coca', 'glacon'}, name = 'whiskycoca', label = "Faire un Whisky-Coca", desc = "Requis: ~b~Whisky~s~/~b~Coca-Cola~s~/~b~Glaçons" },
        { needs = {'vodka', 'crazytiger', 'glacon'}, name = 'vodkacrazy', label = "Faire une Vodka-Crazy", desc = "Requis: ~b~Vodka~s~/~b~Crazytiger~s~/~b~Glaçons" },
        { needs = {'rhumblanc', 'menthe', 'eaugazeuse', 'citronvert', 'siropcanne', 'glacon'}, name = 'mojito', label = "Faire un Mojito", desc = "Requis: ~b~Rhum Blanc~s~/~b~Menthe~s~/~b~Eau Gazeuse~s~/~b~Citron Vert~s~/~b~Sirop de Sucre de Canne~s~/~b~Glaçons" },
        { needs = {'biere', 'limonade', 'grenadine', 'glacon'}, name = 'monaco', label = "Faire un Monaco", desc = "Requis: ~b~Bière~s~/~b~Limonade~s~/~b~Sirop de Grenadine~s~/~b~Glaçons" },
        { needs = {'gin', 'schweppes', 'glacon'}, name = 'gintonic', label = "Faire un Gin-Tonic", desc = "Requis: ~b~Gin~s~/~b~Schweppes~s~/~b~Glaçons" },
        { needs = {'ricard', 'menthe', 'glacon'}, name = 'perroquet', label = "Faire un Perroquet", desc = "Requis: ~b~Ricard~s~/~b~Menthe~s~/~b~Glaçons" },
        { needs = {'ricard', 'orgeat', 'glacon'}, name = 'mauresque', label = "Faire un Mauresque", desc = "Requis: ~b~Ricard~s~/~b~Orgeat~s~/~b~Glaçons" },
        { needs = {'rhum', 'coca', 'glacon'}, name = 'coubalibre', label = "Faire un Coubalibre", desc = "Requis: ~b~Rhum~s~/~b~Coca-Cola~s~/~b~Glaçons" },
        { needs = {'menthe', 'limonade', 'glacon'}, name = 'diabolomenthe', label = "Faire un Diabolo Menthe", desc = "Requis: ~b~Menthe~s~/~b~Limonade~s~/~b~Glaçons" },
        { needs = {'rhum', 'jusdefruit', 'glacon'}, name = 'punch', label = "Faire un Punch", desc = "Requis: ~b~Rhum~s~/~b~Jus de Fruits~s~/~b~Glaçons" },
        -- { needs = { '' }, name = '', label = "Faire un", desc = "" },
    },
}