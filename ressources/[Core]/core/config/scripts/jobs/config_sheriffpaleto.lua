
Config['job_sheriffpaleto'] = {
    SheriffStations = {
        -- = {
            vestiaire = {
                pos = vector3(-439.2, 6010.5, 36.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

                action = function()
                    SheriffPaletoJob.OpenVestiaireMenu()
                end
            },
            armurerie = {
                pos = vector3(-448.4, 6015.6, 36.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'armurerie ",

                action = function()
                    SheriffPaletoJob.OpenArmurerieMenu()
                end
            },
            garage = {
                pos = vector3(-461.0, 5998.5, 31.4),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

                action = function()
                    SheriffPaletoJob.OpenGarageMenu()
                end
            },
            garage2 = {
                pos = vector3(-474.2, 5989.0, 31.3),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage Helicoptère",

                action = function()
                    SheriffPaletoJob.OpenGarage2Menu()
                end
            },
            saisies = {
                pos = vector3(1824.2, 3660.3, 30.3),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder aux Saisies",

                action = function()
                    SheriffPaletoJob.OpenSaisiesMenu()
                end
            },
            deleters = {
                pos = {
                    vector3(-469.1, 6012.4, 31.3),
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
                pos = vector3(-432.6, 6006.2, 36.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

                action = function()
                    -- WL grades non obligatoire, access to boss actions & remove items on coffre --
                    local wlGrades = {'boss'}
                    TriggerEvent('bossManagement:openMenu', 'sheriffpaleto', wlGrades)
                end
            }
        --}
    },

    Tenues = {
        { minGrade = 0, label = "Officier I", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 1,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 1,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 1, label = "Officier II", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 1,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 1,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 2, label = "Officier III", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 1,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 1,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 3, label = "Sergent I", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 2,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 2,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 4, label = "Sergent II", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 2,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 2,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 5, label = "Lieutenant I", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 40,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 40,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 6, label = "Lieutenant II", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 40,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 40,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 7, label = "Capitaine", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 40,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 40,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},

        { minGrade = 8, label = "Commandant", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},
        { minGrade = 9, label = "Deputy Sheriff", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 4,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 4,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},
        { minGrade = 10, label = "Under Sheriff", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 4,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 4,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }},
        { minGrade = 11, label = "Sheriff", skin = {
            m = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 13,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            },
            f = {
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1']  = 312,
                ['torso_2']  = 2,
                ['decals_1'] = 82,
                ['decals_2'] = 0,
                ['arms']     = 1,
                ['pants_1']  = 179,
                ['pants_2']  = 0,
                ['shoes_1']  = 129,
                ['shoes_2']  = 0,
                ['helmet_1'] = 13,
                ['helmet_2'] = 0,
                ['bproof_1'] = 0,
                ['bproof_2'] = 0
            }
        }}
    },

    GPB = {
        { label = "N°1", skin = {
            m = {
                ['bproof_1'] = 7,
                ['bproof_2'] = 1
            }, 
            f = {
                ['bproof_1'] = 16,
                ['bproof_2'] = 1
            }, 
        }},
        { label = "N°2", skin = {
            m = {
                ['bproof_1'] = 13,
                ['bproof_2'] = 3
            }, 
            f = {
                ['bproof_1'] = 15,
                ['bproof_2'] = 1
            }, 
        }},
        { label = "N°3", skin = {
            m = {
                ['bproof_1'] = 14,
                ['bproof_2'] = 1
            }, 
            f = {
                ['bproof_1'] = 72,
                ['bproof_2'] = 1
            }, 
        }},
    },

    Sacs = {
        { label = "N°1", skin = {
            m = {
                ['bags_1'] = 75,
                ['bags_2'] = 0
            }, 
            f = {
                ['bags_1'] = 70,
                ['bags_2'] = 0
            }, 
        }},
    },

    Armurerie = {
        { minGrade = 0, model = 'weapon_flashlight', label = "Lampe torche" },
        { minGrade = 0, model = 'WEAPON_NIGHTSTICK',  label = "Matraque" },
        { minGrade = 0, model = 'WEAPON_STUNGUN', label = "Tazer" },

        { minGrade = 1, model = 'WEAPON_COMBATPISTOL',  label = "Pistolet de Combat" },
        { minGrade = 2, model = 'WEAPON_SMOKEGRENADE',  label = "Fumigène" },
        { minGrade = 4, model = 'WEAPON_SMG',  label = "SMG" },
        { minGrade = 4, model = 'WEAPON_MILITARYRIFLE',  label = "Fusil militaire" },
        { minGrade = 6, model = 'WEAPON_CARBINERIFLE',  label = "M4" },
        { minGrade = 8, model = 'WEAPON_PUMPSHOTGUN',  label = "Fusil à Pompe" },
        { minGrade = 9, model = 'WEAPON_SNIPERRIFLE',  label = "Sniper" },
    },

    Garage = {
        SpawnPos = vector3(-469.1, 6012.4, 31.3),
        SpawnHeading = -130.91,

        Categories = {
            { minGrade = 1, name = 'base',    label = "Véhicules Sheriff" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'sheriff', label = "Sheriff Cruiser 1"},
            { categorie = 'base', minGrade = 0, model = 'sheriff2', label = "Sheriff SUV"},
            { categorie = 'base', minGrade = 1, model = 'lcumkalamo', label = "Sheriff Kalamo"},
            { categorie = 'base', minGrade = 1, model = 'lcumkrumpo', label = "Sheriff rumpo"},
            { categorie = 'base', minGrade = 1, model = 'lcumkscout', label = "Sheriff scout"}, -- handling de merde
            { categorie = 'base', minGrade = 1, model = 'lcumkspeedo', label = "Sheriff Speedo"},
            { categorie = 'base', minGrade = 1, model = 'lcumkstan', label = "Sheriff Stan"}, -- handling de merde
            { categorie = 'base', minGrade = 1, model = 'lcumksteed', label = "Sheriff Steed"},
            { categorie = 'base', minGrade = 1, model = 'lcumktore', label = "Sheriff Tore"},
            { categorie = 'base', minGrade = 1, model = 'lcumktore2', label = "Sheriff Tore 2"},
        }
    },

    Garage2 = {
        SpawnPos = vector3(-474.2, 5989.0, 31.3),
        SpawnHeading = 95.91,

        Categories = {
            { minGrade = 6, name = 'helico', label = "Helicoptères" }
        },

        Helicos = {
            { categorie = 'helico', minGrade = 6, model = 'buzzard2', label = "Sheriff Helico"}
        }
    },
}