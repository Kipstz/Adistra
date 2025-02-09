
Config['job_swat'] = {
    Stations = {
        --Vespucci = {
            -- vestiaire = {
            --     pos = vector3(567.6, -2780.3, 6.1),
            --     msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            --     action = function()
            --         SwatJob.OpenVestiaireMenu()
            --     end
            -- },
            armurerie = {
                pos = vector3(-403.0, -377.4, 25.0),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'armurerie ",

                action = function()
                    SwatJob.OpenArmurerieMenu()
                end
            },
            garage = {
                pos = vector3(-387.7, -365.1, 24.7),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

                action = function()
                    SwatJob.OpenGarageMenu()
                end
            },
            garage2 = {
                pos = vector3(-401.6, -350.8, 70.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage Helicoptère",

                action = function()
                    SwatJob.OpenGarage2Menu()
                end
            },
            deleters = {
                pos = {
                    vector3(-387.7, -365.1, 24.7),
                    vector3(-393.7, -336.3, 72.8),
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
                pos = vector3(-385.4, -356.9, 43.5),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

                action = function()
                    -- WL grades non obligatoire, access to boss actions & remove items on coffre --
                    local wlGrades = {'boss'}
                    TriggerEvent('bossManagement:openMenu', 'swat', wlGrades)
                end
            }
        --}
    },

    Tenues = {
        -- CADET --
        { minGrade = 0, label = "Cadet", skin = {
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
        { minGrade = 0, model = 'weapon_flashlight', label = "Lampe torche" },
        { minGrade = 0, model = 'WEAPON_NIGHTSTICK',  label = "Matraque" },
        { minGrade = 0, model = 'WEAPON_STUNGUN', label = "Tazer" },

        { minGrade = 1, model = 'WEAPON_COMBATPISTOL',  label = "Pistolet de Combat" },
        { minGrade = 2, model = 'WEAPON_SMOKEGRENADE',  label = "Bombe lacrymogène" },
        { minGrade = 4, model = 'WEAPON_SMG',  label = "SMG" },
        { minGrade = 4, model = 'WEAPON_MILITARYRIFLE',  label = "Fusil militaire" },
        { minGrade = 6, model = 'WEAPON_CARBINERIFLE',  label = "M4" },
        { minGrade = 8, model = 'WEAPON_PUMPSHOTGUN',  label = "Fusil à Pompe" },
        { minGrade = 9, model = 'WEAPON_SNIPERRIFLE',  label = "Sniper" },
    },

    Garage = {
        SpawnPos = vector3(-371.7, -366.2, 24.7),
        SpawnHeading = 352.4,

        Categories = {
            { minGrade = 0, name = 'base',    label = "Véhicules" },
            { minGrade = 7, name = 'swat', label = "Swat"},
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'riot', label = "Riot"},
            { categorie = 'base', minGrade = 1, model = 'riot2', label = "Riot 2"},
            { categorie = 'base', minGrade = 0, model = 'fbi', label = "Véhicule"},
            { categorie = 'base', minGrade = 1, model = 'fbi2', label = "Véhicule 2"},

            { categorie = 'swat', minGrade = 7, model = 'swatinsur', label = "SWAT Insurgent"},
            { categorie = 'swat', minGrade = 7, model = 'swatstoc', label = "SWAT Riot"},
            { categorie = 'swat', minGrade = 7, model = 'swatvanr', label = "Police SWAT Transporter"},
            { categorie = 'swat', minGrade = 7, model = 'swatvanr2', label = "Police SWAT Transporter 2"},
            { categorie = 'swat', minGrade = 7, model = 'swatvans', label = "Police SWAT Transporter 3"},
            { categorie = 'swat', minGrade = 7, model = 'swatvans2', label = "Police SWAT Transporter 4"},
        }
    },

    Garage2 = {
        SpawnPos = vector3(-393.7, -336.3, 72.8),
        SpawnHeading = 95.91,

        Categories = {
            { minGrade = 6, name = 'helico', label = "Helicoptères" }
        },

        Helicos = {
            { categorie = 'helico', minGrade = 6, model = 'buzzard2', label = "Buzzard"}
        }
    },
}