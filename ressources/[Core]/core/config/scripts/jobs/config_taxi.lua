Config['job_taxi'] = {
    Points = {
        vestiaire = {
            pos = vector3(-193.9, -1337.2, 31.3),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                TaxiJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(893.5, -146.8, 76.9),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                TaxiJob.OpenGarageMenu()
            end
        },
        deleters = {
            pos = {
                vector3(897.8, -151.6, 76.5),
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
            pos = vector3(906.2, -151.7, 74.2),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'taxi')
            end
        }
    },

    Tenues = {
        { label = "Tenue Taxi", skin = {
            m = {
                ['tshirt_1'] = 143,
                ['tshirt_2'] = 0,
                ['torso_1']  = 135,
                ['torso_2']  = 3,
                ['arms']     = 35,
                ['pants_1']  = 132,
                ['pants_2']  = 0,
                ['shoes_1']  = 10,
                ['shoes_2']  = 0,
            },
            f = {
                ['tshirt_1'] = 151,
                ['tshirt_2'] = 0,
                ['torso_1']  = 202,
                ['torso_2']  = 2,
                ['arms']     = 71,
                ['pants_1']  = 245,
                ['pants_2']  = 0,
                ['shoes_1']  = 81,
                ['shoes_2']  = 0,
            }
        }},
    },

    Garage = {
        SpawnPos = vector3(897.8, -151.6, 76.5),
        SpawnHeading = -30.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules Taxi" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'taxi', label = "Taxi"},
            { categorie = 'base', minGrade = 1, model = 'schafter3', label = "Uber"},
        }
    },

    Missions = {
        wlVehicles = { `taxi`, `schafter3` },
        rewards = { 
            [0] = { min = 150, max = 650, kmMultiplier = 1.5 },
            [1] = { min = 250, max = 700, kmMultiplier = 2.0 },
            [2] = { min = 250, max = 700, kmMultiplier = 2.0 },
            [3] = { min = 250, max = 700, kmMultiplier = 2.0 },
        },
        models = {
            `s_m_m_cntrybar_01`,
            `u_f_y_comjane`,
            `a_f_y_hipster_04`,
            `s_m_m_highsec_02`,
            `a_m_y_hipster_03`,
        },
        localisations = {
            vector4(946.32, -171.73, 74.52, 56.16),
            vector4(963.37, -149.65, 73.91, 239.32),
            vector4(397.99, -870.35, 29.21, 322.19),
            vector4(59.27, -1483.81, 29.27, 270.60),
            vector4(1246.32, -1453.95, 34.93, 344.25),
            vector4(-289.31, -1847.96, 26.24, 4.33),
            vector4(-45.84, -1029.78, 28.62, 71.53),
            vector4(181.96, -322.10, 43.93, 211.44),
            vector4(-514.85, -260.63, 35.53, 211.89),
            vector4(-1284.61, 297.23, 64.94, 154.28),
            vector4(-1440.09, -773.82, 23.43, 343.20),
        }
    }
}