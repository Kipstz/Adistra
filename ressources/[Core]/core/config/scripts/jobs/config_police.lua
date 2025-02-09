
Config['job_police'] = {
    PoliceStations = {
        --Vespucci = {
            vestiaire = {
                pos = vector3(-398.8, -366.3, 25.0),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

                action = function()
                    PoliceJob.OpenVestiaireMenu()
                end
            },
            armurerie = {
                pos = vector3(-403.0, -377.4, 25.0),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'armurerie ",

                action = function()
                    PoliceJob.OpenArmurerieMenu()
                end
            },
            garage = {
                pos = vector3(-387.7, -365.1, 24.7),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

                action = function()
                    PoliceJob.OpenGarageMenu()
                end
            },
            garage2 = {
                pos = vector3(-401.6, -350.8, 70.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage Helicoptère",

                action = function()
                    PoliceJob.OpenGarage2Menu()
                end
            },
            garage3 = {
                pos = vector3(-414.5, -318.8, 34.5),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

                action = function()
                    PoliceJob.OpenGarage3Menu()
                end
            },
            saisies = {
                pos = vector3(-414.0, -400.1, 25.0),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder aux Saisies",

                action = function()
                    PoliceJob.OpenSaisiesMenu()
                end
            },
            deleters = {
                pos = {
                    vector3(-382.0, -365.5, 24.7),
                    vector3(-377.9, -355.1, 72.8),
                    vector3(-420.5, -310.2, 34.3),
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
                pos = vector3(-383.8, -358.3, 48.5),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

                action = function()
                    -- WL grades non obligatoire, access to boss actions & remove items on coffre --
                    local wlGrades = {'boss'}
                    TriggerEvent('bossManagement:openMenu', 'police', wlGrades)
                end
            }
        --}
    },

    Tenues = {
        -- Rookie --
        { minGrade = 0, label = "Rookie", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 567,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 83,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 327,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 117,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},
        -- Officier I --
        { minGrade = 1, label = "Officier I", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 567,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 327,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},
        -- Officier II --
        { minGrade = 2, label = "Officier II", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 567,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 327,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},
        -- Officier III --
        { minGrade = 3, label = "Officier III", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 567,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 327,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 1,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 4, label = "Caporal", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 0,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 1,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 5, label = "Caporal Chef", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 0,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 1,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 6, label = "Major", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 1,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 6,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 7, label = "Major Chef", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 1,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 6,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 8, label = "Adjudant", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 2,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 2,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 9, label = "Adjudant Chef", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 2,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 2,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},
        
        { minGrade = 10, label = "Sergent", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 3,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 5,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 11, label = "Sergent Chef", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 266,
                ['decals_2'] = 3,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 339,
                ['decals_2'] = 5,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 12, label = "Lieutenant", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 0,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 6,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 13, label = "Lieutenant Chef", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 0,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 6,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 14, label = "Capitaine", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 1,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 0,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 15, label = "Commandant", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 2,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 2,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 16, label = "Deputy Chief", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 3,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 3,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 17, label = "Assistant Chief", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 4,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 4,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }},

        { minGrade = 18, label = "Chief ", skin = {
            m = {
                ['tshirt_1'] = 211,
                ['tshirt_2'] = 0,
                ['torso_1']  = 563,
                ['torso_2']  = 0,
                ['decals_1'] = 257,
                ['decals_2'] = 5,
                ['arms']     = 11,
                ['pants_1']  = 200,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 82,
                ['bproof_2'] = 0,
                ['chain_1'] = 183,
                ['chain_2'] = 0
            },
            f = {
                ['tshirt_1'] = 190,
                ['tshirt_2'] = 0,
                ['torso_1']  = 330,
                ['torso_2']  = 0,
                ['decals_1'] = 340,
                ['decals_2'] = 5,
                ['arms']     = 14,
                ['pants_1']  = 34,
                ['pants_2']  = 0,
                ['shoes_1']  = 24,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 255,
                ['bproof_2'] = 0,
                ['chain_1'] = 234,
                ['chain_2'] = 0
            }
        }}
    },

    GPB = {
        { label = "GPB", skin = {
            m = {
                ['bproof_1'] = 82,
                ['bproof_2'] = 0
            }, 
            f = {
                ['bproof_1'] = 255,
                ['bproof_2'] = 0
            }, 
        }}
    },

    Sacs = {
        { label = "N°1", skin = {
            m = {
                ['bags_1'] = 211,
                ['bags_2'] = 0
            }, 
            f = {
                ['bags_1'] = 277,
                ['bags_2'] = 0
            }, 
        }},
    },

    Armurerie = {
        { minGrade = 0, model = 'weapon_flashlight', label = "Lampe torche" },
        { minGrade = 0, model = 'WEAPON_NIGHTSTICK',  label = "Matraque" },
        { minGrade = 0, model = 'WEAPON_STUNGUN', label = "Tazer" },

        { minGrade = 1, model = 'WEAPON_COMBATPISTOL',  label = "Pistolet de Combat" },
        { minGrade = 13, model = 'WEAPON_SMOKEGRENADE',  label = "Bombe lacrymogène" },
        { minGrade = 8, model = 'WEAPON_SMG',  label = "SMG" },
        { minGrade = 13, model = 'WEAPON_MILITARYRIFLE',  label = "Fusil militaire" },
        { minGrade = 10, model = 'WEAPON_CARBINERIFLE',  label = "M4" },
        { minGrade = 6, model = 'WEAPON_PUMPSHOTGUN',  label = "Fusil à Pompe" },
        { minGrade = 13, model = 'WEAPON_SNIPERRIFLE',  label = "Sniper" },
    },

    Garage = {
        SpawnPos = vector3(-382.0, -365.5, 24.7),
        SpawnHeading = 81.3,

        Categories = {
            { minGrade = 0, name = 'base',    label = "Véhicules LSPD" },
            { minGrade = 15, name = 'rapides',    label = "Véhicules Rapides" },
            { minGrade = 15, name = 'bana',    label = "Véhicules Banalisé" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'police', label = "Police 0"}, -- Rookie / Officier I

            { categorie = 'base', minGrade = 2, model = 'police10', label = "Police 1"}, -- Officier II
            { categorie = 'base', minGrade = 4, model = 'police13', label = "Police 2"}, -- Caporal
            { categorie = 'base', minGrade = 4, model = 'police14', label = "Police 3"}, -- Caporal
            { categorie = 'base', minGrade = 4, model = 'police19', label = "Police 4"}, -- Caporal
            { categorie = 'base', minGrade = 6, model = 'police15', label = "Police 5"}, -- Major
            { categorie = 'base', minGrade = 6, model = 'police16', label = "Police 6"}, -- Major
            { categorie = 'base', minGrade = 8, model = 'police18', label = "Police 7"}, -- Adjudant
            { categorie = 'base', minGrade = 10, model = 'police12', label = "Police 8"}, -- Sergent

            { categorie = 'rapides', minGrade = 15, model = 'nm_z71', label = "Police 9"}, -- Commandant
            { categorie = 'rapides', minGrade = 15, model = 'polsilverado19', label = "Police 10"}, -- Commandant
            { categorie = 'rapides', minGrade = 15, model = 'polmustang', label = "Police 11"}, -- Commandant

            { categorie = 'bana', minGrade = 15, model = 'buffalosxpol', label = "Buffalo STX"}, -- Commandant
            { categorie = 'bana', minGrade = 15, model = 'policefelon', label = "Felon"}, -- Commandant

        }
    },

    Garage3 = {
        SpawnPos = vector3(-420.5, -310.2, 34.3),
        SpawnHeading = 352.8,

        Categories = {
            { minGrade = 14, name = 'bus',    label = "Bus" },
            { minGrade = 14, name = 'swat',    label = "Véhicules Swat" },
        },

        Vehicules = {
            { categorie = 'bus', minGrade = 14, model = 'police17', label = "Bus"}, -- Capitaine
            { categorie = 'swat', minGrade = 14, model = 'riot', label = "SWAT Riot"}, -- Capitaine
            { categorie = 'swat', minGrade = 14, model = 'insurgent2', label = "Insurgent"}, -- Capitaine
        }
    },

    Garage2 = {
        SpawnPos = vector3(-377.9, -355.1, 72.8),
        SpawnHeading = 95.91,

        Categories = {
            { minGrade = 6, name = 'helico', label = "Helicoptères" }
        },

        Helicos = {
            { categorie = 'helico', minGrade = 6, model = 'police11', label = "Helicoptères"}
        }
    },
}