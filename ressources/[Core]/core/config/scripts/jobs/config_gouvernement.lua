
Config['job_gouvernement'] = {
    GouvernementStations = {
        --Gouv = {
            vestiaire = {
                pos = vector3(-536.3, -182.8, 38.2),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

                action = function()
                    GouvernementJob.OpenVestiaireMenu()
                end
            },
            armurerie = {
                pos = vector3(-561.4, -210.8, 42.8),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'armurerie ",

                action = function()
                    GouvernementJob.OpenArmurerieMenu()
                end
            },
            garage = {
                pos = vector3(-582.8, -148.4, 38.2),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

                action = function()
                    GouvernementJob.OpenGarageMenu()
                end
            },
            garage2 = {
                pos = vector3(-596.1, -133.4, 39.6),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage Helicoptère",

                action = function()
                    GouvernementJob.OpenGarage2Menu()
                end
            },
            deleters = {
                pos = {
                    vector3(-574.9, -151.2, 38.0),
                    vector3(-609.6, -129.8, 38.7),
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
                pos = vector3(-547.7, -200.1, 47.6),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

                action = function()
                    -- WL grades non obligatoire, access to boss actions & remove items on coffre --
                    local wlGrades = {'boss'}
                    TriggerEvent('bossManagement:openMenu', 'gouvernement', wlGrades)
                end
            }
        --}
    },

    Tenues = {
        -- { minGrade = 0, label = "Secretaire", skin = {
        --     m = {
        --         ['tshirt_1'] = 15,
        --         ['tshirt_2'] = 0,
        --         ['torso_1']  = 312,
        --         ['torso_2']  = 0,
        --         ['decals_1'] = 0,
        --         ['decals_2'] = 0,
        --         ['arms']     = 1,
        --         ['pants_1']  = 179,
        --         ['pants_2']  = 0,
        --         ['shoes_1']  = 129,
        --         ['shoes_2']  = 0,
        --         ['helmet_1'] = 1,
        --         ['helmet_2'] = 0,
        --         ['bproof_1'] = 59,
        --         ['bproof_2'] = 0
        --     },
        --     f = {
        --         ['tshirt_1'] = 15,
        --         ['tshirt_2'] = 0,
        --         ['torso_1']  = 312,
        --         ['torso_2']  = 0,
        --         ['decals_1'] = 0,
        --         ['decals_2'] = 0,
        --         ['arms']     = 1,
        --         ['pants_1']  = 179,
        --         ['pants_2']  = 0,
        --         ['shoes_1']  = 129,
        --         ['shoes_2']  = 0,
        --         ['helmet_1'] = 1,
        --         ['helmet_2'] = 0,
        --         ['bproof_1'] = 59,
        --         ['bproof_2'] = 0
        --     }
        -- }},
        { minGrade = 1, label = "Agent de sécurité", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 59,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 59,
                ['bproof_2'] = 0
            }
        }},
    },

    GPB = {
        { label = "N°1", skin = {
            m = {
                ['bproof_1'] = 7,
                ['bproof_2'] = 0
            }, 
            f = {
                ['bproof_1'] = 16,
                ['bproof_2'] = 0
            }, 
        }},
    },

    Sacs = {
        { label = "N°1", skin = {
            m = {
                ['bags_1'] = 76,
                ['bags_2'] = 0
            }, 
            f = {
                ['bags_1'] = 71,
                ['bags_2'] = 0
            }, 
        }},
    },

    Armurerie = {
        { minGrade = 1, model = 'weapon_flashlight', label = "Lampe torche" },
        { minGrade = 1, model = 'WEAPON_NIGHTSTICK',  label = "Matraque" },
        { minGrade = 1, model = 'WEAPON_STUNGUN', label = "Tazer" },

        { minGrade = 1, model = 'WEAPON_COMBATPISTOL',  label = "Pistolet de Combat" },
    },

    Garage = {
        SpawnPos = vector3(-574.9, -151.2, 38.0),
        SpawnHeading = -130.91,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'baller6', label = "Baller"},

            { categorie = 'base', minGrade = 0, model = 'pressuv', label = "SUV"},
            { categorie = 'base', minGrade = 0, model = 'cat', label = "Véhicule 1"},
            { categorie = 'base', minGrade = 0, model = 'halfback', label = "Véhicule 2"},
            { categorie = 'base', minGrade = 0, model = 'halfback2', label = "Véhicule 3"},
            { categorie = 'base', minGrade = 0, model = 'hazard', label = "Véhicule 4"},
            { categorie = 'base', minGrade = 0, model = 'hazard2', label = "Véhicule 5"},
            { categorie = 'base', minGrade = 0, model = 'idcar', label = "Véhicule 6"},
            { categorie = 'base', minGrade = 0, model = 'inaugural', label = "Véhicule 7"},
            { categorie = 'base', minGrade = 0, model = 'inaugural2', label = "Véhicule 8"},
            { categorie = 'base', minGrade = 0, model = 'roadrunner', label = "Véhicule 9"},
            { categorie = 'base', minGrade = 0, model = 'roadrunner2', label = "Véhicule 10"},
            { categorie = 'base', minGrade = 0, model = 'roadrunner3', label = "Véhicule 11"},
            { categorie = 'base', minGrade = 0, model = 'usssminigun', label = "Véhicule 12"},
            { categorie = 'base', minGrade = 0, model = 'usssminigun2', label = "Véhicule 13"},
            { categorie = 'base', minGrade = 0, model = 'ussssuv', label = "Véhicule 14"},
            { categorie = 'base', minGrade = 0, model = 'ussssuv2', label = "Véhicule 15"},
            { categorie = 'base', minGrade = 0, model = 'usssvan', label = "Véhicule 16"},
            { categorie = 'base', minGrade = 0, model = 'usssvan2', label = "Véhicule 17"},
            { categorie = 'base', minGrade = 0, model = 'watchtower', label = "Véhicule 18"},
            { categorie = 'base', minGrade = 0, model = 'watchtower2', label = "Véhicule 19"},
        }
    },

    Garage2 = {
        SpawnPos = vector3(-609.6, -129.8, 38.7),
        SpawnHeading = 95.91,

        Categories = {
            { minGrade = 6, name = 'helico', label = "Helicoptères" }
        },

        Helicos = {
            { categorie = 'helico', minGrade = 6, model = 'frogger', label = "Frogger"},
            { categorie = 'helico', minGrade = 6, model = 'presheli', label = "Heli"},
            { categorie = 'helico', minGrade = 6, model = 'presheli2', label = "Heli 2"},
        }
    },
}