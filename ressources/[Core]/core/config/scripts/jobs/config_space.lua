Config['job_space'] = {
    Points = {
        vestiaire = {
            pos = vector3(1721.2, 2674.1, 45.9),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                SpaceJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(1770.4, 2615.8, 46.5),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                SpaceJob.OpenGarageMenu()
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
            pos = vector3(1720.2, 2661.0, 51.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'space')
            end
        }
    },

    Tenues = {
        { label = "Combinaison", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 283,
                ['torso_2']  = 0,
                ['arms']     = 166,
                ['pants_1']  = 110,
                ['pants_2']  = 0,
                ['shoes_1']  = 88,
                ['shoes_2']  = 0,
                ['helmet_1']  = 133,
                ['helmet_2']  = 0,
                ['mask_1']  = 185,
                ['mask_2']  = 1,
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 296,
                ['torso_2']  = 0,
                ['arms']     = 88,
                ['pants_1']  = 117,
                ['pants_2']  = 0,
                ['shoes_1']  = 215,
                ['shoes_2']  = 1,
                ['helmet_1']  = 77,
                ['helmet_2']  = 0,
                ['mask_1']  = 185,
                ['mask_2']  = 2,
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
        SpawnPos = vector3(1738.0, 2583.0, 47.0),
        SpawnHeading = 70.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
            { minGrade = 0, name = 'space', label = "Special" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'dune2', label = "Space Docker"},
            { categorie = 'base', minGrade = 0, model = 'bus', label = "Bus"},
            { categorie = 'space', minGrade = 1, model = 'shuttle', label = "Fusée (!)"},

        }
    },
}