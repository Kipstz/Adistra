Config['jobcenter'] = {
    ['center'] = {
        pos = vector3(-268.7, -956.9, 31.2),
        pedModel = 'u_f_m_casinoshop_01',
        pedHeading = -140.0
    },
    ['metiers'] = {
        ['mineur'] = {
            name = 'mineur',
            label = 'Mineur',
            desc = "~b~Ce métier consiste à aller chercher des pierres, les laver pour en obtenir des minerais puis les transformer à la fonderie.~s~"
        },
        ['tabac'] = {
            name = 'tabac',
            label = 'Tabac',
            desc = "~b~Ce métier consiste à récolter des feuilles de tabac pour en faire des cigarettes.~s~"
        },
    },
    ['points'] = {
        ['mineur'] = {
            jobRequired = 'mineur',
            jobLabel = "Mineur",

            ['base'] = {
                pedModel = 's_m_m_gardener_01',
                pedHeading = 180.0,
                pos = vector3(892.4, -2172.0, 32.3),

                blip = {
                    label = "Mineur | Base",
                    pos = vector3(892.4, -2172.0, 32.3),
                    sprite = 618,
                    color = 1
                },
                garage = {
                    pos = vector3(877.8, -2199.0, 30.5),
                    spawn = vector3(874.8, -2189.6, 30.5),
                    heading = 90.0,

                    vehicules = {
                        { name = 'tiptruck', label = "Camion (Tipper)" },
                        { name = 'tiptruck2', label = "Camion (Tipper 2)" },
                    },

                    -- DELETERS --
                    deleters = vector3(874.8, -2189.6, 30.5),
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
                tenue = {
                   skin = {
                        m = {
                            ['tshirt_1'] = 170,
                            ['tshirt_2'] = 1,
                            ['torso_1']  = 168,
                            ['torso_2']  = 0,
                            ['arms']     = 216,
                            ['pants_1']  = 171,
                            ['pants_2']  = 2,
                            ['shoes_1']  = 131,
                            ['shoes_2']  = 0,
                            ['helmet_1'] = 183,
                            ['helmet_1'] = 0,
                            ['bags_1'] = 75,
                            ['bags_2'] = 0,
                        },
                        f = {
                            ['tshirt_1'] = 148,
                            ['tshirt_2'] = 1,
                            ['torso_1']  = 135,
                            ['torso_2']  = 0,
                            ['arms']     = 116,
                            ['pants_1']  = 161,
                            ['pants_2']  = 0,
                            ['shoes_1']  = 87,
                            ['shoes_2']  = 0,
                            ['helmet_1'] = 160,
                            ['helmet_1'] = 0,
                            ['bags_1'] = 121,
                            ['bags_2'] = 0,
                        }
                    }
                }
            },
            ['harvest'] = {
                msg = "Récolte en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(3001.1, 2770.8, 42.9), 
                    vector3(3000.0, 2763.2, 42.9), 
                    vector3(2982.3, 2818.4, 44.9),
                    vector3(2989.6, 2805.1, 44.2),
                    vector3(2990.4, 2754.1, 43.0),
                    vector3(2946.3, 2731.3, 46.3),
                    vector3(2937.2, 2745.0, 43.3)
                },
                blip = {
                    label = "Mineur | Récolte",
                    pos = vector3(3001.1, 2770.8, 42.9),
                    sprite = 618,
                    color = 1
                },
                item = 'pierres'
            },
            ['treatment'] = {
                msg = "Traitement en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(2197.8, 3901.0, 30.6), 
                    vector3(2184.8, 3908.2, 30.2) 
                },
                blip = {
                    label = "Mineur | Traitement",
                    pos = vector3(2197.8, 3901.0, 30.6),
                    sprite = 618,
                    color = 1
                },
                itemRequired = 'pierres',
                item = 'minerais'
            },
            ['craft'] = {
                msg = "Transformation en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(1108.3, -2007.3, 30.9) 
                },
                blip = {
                    label = "Mineur | Transformation",
                    pos = vector3(1108.3, -2007.3, 30.9),
                    sprite = 618,
                    color = 1
                },
                itemRequired = 'minerais',
                items = { 
                    --% de chance
                    ['fer'] = 220,
                    ['cuivre'] = 210,
                    ['or'] = 200, 
                    ['diamant'] = 190, 
                }
            },
            ['sell'] = {
                msg = "Vente en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(873.0, -2199.4, 30.5) 
                },
                blip = {
                    label = "Mineur | Vente",
                    pos = vector3(873.0, -2199.4, 30.5),
                    sprite = 618,
                    color = 1
                },
                itemsRequireds = { 'fer', 'cuivre', 'or', 'diamant' },
                prices = {
                    ['fer'] = 1000,
                    ['cuivre'] = 1000,
                    ['or'] = 1000, 
                    ['diamant'] = 1000, 
                }
            },
        },
        ['tabac'] = {
            jobRequired = 'tabac',
            jobLabel = "Tabac",

            ['base'] = {
                pedModel = 's_m_m_gardener_01',
                pedHeading = 180.0,
                pos = vector3(2340.5, 3123.0, 48.2),

                blip = {
                    label = "Tabac | Base",
                    pos = vector3(2340.5, 3123.0, 48.2),
                    sprite = 618,
                    color = 1
                },
                garage = {
                    pos = vector3(2365.7, 3135.9, 48.2),
                    spawn = vector3(2369.0, 3130.1, 48.4),
                    heading = 90.0,

                    vehicules = {
                        { name = 'burrito3', label = "Burrito" },
                    },

                    -- DELETERS --
                    deleters = vector3(2369.0, 3130.1, 48.4),
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
                tenue = {
                   skin = {
                        m = {
                            ['tshirt_1'] = 170,
                            ['tshirt_2'] = 1,
                            ['torso_1']  = 168,
                            ['torso_2']  = 0,
                            ['arms']     = 216,
                            ['pants_1']  = 171,
                            ['pants_2']  = 2,
                            ['shoes_1']  = 131,
                            ['shoes_2']  = 0,
                            ['helmet_1'] = 183,
                            ['helmet_1'] = 0,
                            ['bags_1'] = 75,
                            ['bags_2'] = 0,
                        },
                        f = {
                            ['tshirt_1'] = 148,
                            ['tshirt_2'] = 1,
                            ['torso_1']  = 135,
                            ['torso_2']  = 0,
                            ['arms']     = 116,
                            ['pants_1']  = 161,
                            ['pants_2']  = 0,
                            ['shoes_1']  = 87,
                            ['shoes_2']  = 0,
                            ['helmet_1'] = 160,
                            ['helmet_1'] = 0,
                            ['bags_1'] = 121,
                            ['bags_2'] = 0,
                        }
                    }
                }
            },
            ['harvest'] = {
                msg = "Récolte en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(2858.5, 4609.9, 48.2), 
                    vector3(2848.3, 4608.2, 48.0), 
                },
                blip = {
                    label = "Tabac | Récolte",
                    pos = vector3(2848.3, 4608.2, 48.0),
                    sprite = 618,
                    color = 1
                },
                item = 'feuillestabac'
            },
            ['treatment'] = {
                msg = "Traitement en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(2867.0, 4414.8, 49.1),
                },
                blip = {
                    label = "Tabac | Traitement",
                    pos = vector3(2867.0, 4414.8, 49.1),
                    sprite = 618,
                    color = 1
                },
                itemRequired = 'feuillestabac',
                item = 'tabac'
            },
            ['craft'] = {
                msg = "Transformation en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(2405.1, 3127.4, 48.2) 
                },
                blip = {
                    label = "Tabac | Transformation",
                    pos = vector3(2405.1, 3127.4, 48.2),
                    sprite = 618,
                    color = 1
                },
                itemRequired = 'tabac',
                items = { 
                    --% de chance
                    ['cigaretteblonde'] = 50,
                    ['cigarettebrune'] = 35,
                    ['malboro'] = 15
                }
            },
            ['sell'] = {
                msg = "Vente en Cours...",
                anim = 'PROP_HUMAN_BUM_BIN',
                localisations = { 
                    vector3(2351.6, 3141.8, 48.2) 
                },
                blip = {
                    label = "Tabac | Vente",
                    pos = vector3(2351.6, 3141.8, 48.2),
                    sprite = 618,
                    color = 1
                },
                itemsRequireds = { 'cigaretteblonde', 'cigarettebrune', 'malboro' },
                prices = {
                    ['cigaretteblonde'] = 1000,
                    ['cigarettebrune'] = 1000,
                    ['malboro'] = 1000
                }
            },
        },
    --     ['abatteur'] = {
    --         jobRequired = 'abatteur',
    --         jobLabel = "Abatteur",

    --         ['base'] = {
    --             pedModel = 's_m_m_gardener_01',
    --             pedHeading = 180.0,
    --             pos = vector3(-102.4, 6194.6, 31.0),

    --             blip = {
    --                 label = "Abatteur | Base",
    --                 pos = vector3(-102.4, 6194.6, 31.0),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             garage = {
    --                 pos = vector3(877.8, -2199.0, 30.5),
    --                 spawn = vector3(874.8, -2189.6, 30.5),
    --                 heading = 90.0,

    --                 vehicules = {
    --                     { name = 'burrito3', label = "Burrito" },
    --                 },

    --                 -- DELETERS --
    --                 deleters = vector3(874.8, -2189.6, 30.5),
    --                 action = function()
    --                     local plyPed = PlayerPedId()
    --                     local inVeh = IsPedInAnyVehicle(plyPed)
    
    --                     if inVeh then
    --                         local vehicle = GetVehiclePedIsIn(plyPed)
    
    --                         Framework.Game.DeleteVehicle(vehicle)
    --                     else
    --                         Framework.ShowNotification("~r~Vous devez être dans un Véhicule !")
    --                     end
    --                 end
    --             },
    --             tenue = {
    --                skin = {
    --                     m = {
    --                         ['tshirt_1'] = 170,
    --                         ['tshirt_2'] = 1,
    --                         ['torso_1']  = 168,
    --                         ['torso_2']  = 0,
    --                         ['arms']     = 216,
    --                         ['pants_1']  = 171,
    --                         ['pants_2']  = 2,
    --                         ['shoes_1']  = 131,
    --                         ['shoes_2']  = 0,
    --                         ['helmet_1'] = 183,
    --                         ['helmet_1'] = 0,
    --                         ['bags_1'] = 75,
    --                         ['bags_2'] = 0,
    --                     },
    --                     f = {
    --                         ['tshirt_1'] = 148,
    --                         ['tshirt_2'] = 1,
    --                         ['torso_1']  = 135,
    --                         ['torso_2']  = 0,
    --                         ['arms']     = 116,
    --                         ['pants_1']  = 161,
    --                         ['pants_2']  = 0,
    --                         ['shoes_1']  = 87,
    --                         ['shoes_2']  = 0,
    --                         ['helmet_1'] = 160,
    --                         ['helmet_1'] = 0,
    --                         ['bags_1'] = 121,
    --                         ['bags_2'] = 0,
    --                     }
    --                 }
    --             }
    --         },
    --         ['harvest'] = {
    --             msg = "Récolte en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(3001.1, 2770.8, 42.9), 
    --                 vector3(3000.0, 2763.2, 42.9), 
    --                 vector3(2982.3, 2818.4, 44.9),
    --                 vector3(2989.6, 2805.1, 44.2),
    --                 vector3(2990.4, 2754.1, 43.0),
    --                 vector3(2946.3, 2731.3, 46.3),
    --                 vector3(2937.2, 2745.0, 43.3)
    --             },
    --             blip = {
    --                 label = "Abatteur | Récolte",
    --                 pos = vector3(3001.1, 2770.8, 42.9),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             item = 'pierres'
    --         },
    --         ['treatment'] = {
    --             msg = "Traitement en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(2197.8, 3901.0, 30.6), 
    --                 vector3(2184.8, 3908.2, 30.2) 
    --             },
    --             blip = {
    --                 label = "Abatteur | Traitement",
    --                 pos = vector3(2197.8, 3901.0, 30.6),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             itemRequired = 'pierres',
    --             item = 'minerais'
    --         },
    --         ['craft'] = {
    --             msg = "Transformation en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(1108.3, -2007.3, 30.9) 
    --             },
    --             blip = {
    --                 label = "Abatteur | Transformation",
    --                 pos = vector3(1108.3, -2007.3, 30.9),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             itemRequired = 'minerais',
    --             items = { 
    --                 --% de chance
    --                 ['fer'] = 50,
    --                 ['cuivre'] = 35,
    --                 ['or'] = 10, 
    --                 ['diamant'] = 5, 
    --             }
    --         },
    --         ['sell'] = {
    --             msg = "Vente en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(873.0, -2199.4, 30.5) 
    --             },
    --             blip = {
    --                 label = "Abatteur | Vente",
    --                 pos = vector3(873.0, -2199.4, 30.5),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             itemsRequireds = { 'fer', 'cuivre', 'or', 'diamant' },
    --             prices = {
    --                 ['fer'] = 50,
    --                 ['cuivre'] = 35,
    --                 ['or'] = 10, 
    --                 ['diamant'] = 5, 
    --             }
    --         },
    --     },
    --     ['bucheron'] = {
    --         jobRequired = 'bucheron',
    --         jobLabel = "Bucheron",

    --         ['base'] = {
    --             pedModel = 's_m_m_gardener_01',
    --             pedHeading = 180.0,
    --             pos = vector3(892.4, -2172.0, 32.3),

    --             blip = {
    --                 label = "Bucheron | Base",
    --                 pos = vector3(892.4, -2172.0, 32.3),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             garage = {
    --                 pos = vector3(877.8, -2199.0, 30.5),
    --                 spawn = vector3(874.8, -2189.6, 30.5),
    --                 heading = 90.0,

    --                 vehicules = {
    --                     { name = 'burrito3', label = "Burrito" },
    --                 },

    --                 -- DELETERS --
    --                 deleters = vector3(874.8, -2189.6, 30.5),
    --                 action = function()
    --                     local plyPed = PlayerPedId()
    --                     local inVeh = IsPedInAnyVehicle(plyPed)
    
    --                     if inVeh then
    --                         local vehicle = GetVehiclePedIsIn(plyPed)
    
    --                         Framework.Game.DeleteVehicle(vehicle)
    --                     else
    --                         Framework.ShowNotification("~r~Vous devez être dans un Véhicule !")
    --                     end
    --                 end
    --             },
    --             tenue = {
    --                skin = {
    --                     m = {
    --                         ['tshirt_1'] = 170,
    --                         ['tshirt_2'] = 1,
    --                         ['torso_1']  = 168,
    --                         ['torso_2']  = 0,
    --                         ['arms']     = 216,
    --                         ['pants_1']  = 171,
    --                         ['pants_2']  = 2,
    --                         ['shoes_1']  = 131,
    --                         ['shoes_2']  = 0,
    --                         ['helmet_1'] = 183,
    --                         ['helmet_1'] = 0,
    --                         ['bags_1'] = 75,
    --                         ['bags_2'] = 0,
    --                     },
    --                     f = {
    --                         ['tshirt_1'] = 148,
    --                         ['tshirt_2'] = 1,
    --                         ['torso_1']  = 135,
    --                         ['torso_2']  = 0,
    --                         ['arms']     = 116,
    --                         ['pants_1']  = 161,
    --                         ['pants_2']  = 0,
    --                         ['shoes_1']  = 87,
    --                         ['shoes_2']  = 0,
    --                         ['helmet_1'] = 160,
    --                         ['helmet_1'] = 0,
    --                         ['bags_1'] = 121,
    --                         ['bags_2'] = 0,
    --                     }
    --                 }
    --             }
    --         },
    --         ['harvest'] = {
    --             msg = "Récolte en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(3001.1, 2770.8, 42.9), 
    --                 vector3(3000.0, 2763.2, 42.9), 
    --                 vector3(2982.3, 2818.4, 44.9),
    --                 vector3(2989.6, 2805.1, 44.2),
    --                 vector3(2990.4, 2754.1, 43.0),
    --                 vector3(2946.3, 2731.3, 46.3),
    --                 vector3(2937.2, 2745.0, 43.3)
    --             },
    --             blip = {
    --                 label = "Bucheron | Récolte",
    --                 pos = vector3(3001.1, 2770.8, 42.9),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             item = 'pierres'
    --         },
    --         ['treatment'] = {
    --             msg = "Traitement en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(2197.8, 3901.0, 30.6), 
    --                 vector3(2184.8, 3908.2, 30.2) 
    --             },
    --             blip = {
    --                 label = "Bucheron | Traitement",
    --                 pos = vector3(2197.8, 3901.0, 30.6),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             itemRequired = 'pierres',
    --             item = 'minerais'
    --         },
    --         ['craft'] = {
    --             msg = "Transformation en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(1108.3, -2007.3, 30.9) 
    --             },
    --             blip = {
    --                 label = "Bucheron | Transformation",
    --                 pos = vector3(1108.3, -2007.3, 30.9),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             itemRequired = 'minerais',
    --             items = { 
    --                 --% de chance
    --                 ['fer'] = 50,
    --                 ['cuivre'] = 35,
    --                 ['or'] = 10, 
    --                 ['diamant'] = 5, 
    --             }
    --         },
    --         ['sell'] = {
    --             msg = "Vente en Cours...",
    --             anim = 'PROP_HUMAN_BUM_BIN',
    --             localisations = { 
    --                 vector3(873.0, -2199.4, 30.5) 
    --             },
    --             blip = {
    --                 label = "Bucheron | Vente",
    --                 pos = vector3(873.0, -2199.4, 30.5),
    --                 sprite = 618,
    --                 color = 1
    --             },
    --             itemsRequireds = { 'fer', 'cuivre', 'or', 'diamant' },
    --             prices = {
    --                 ['fer'] = 50,
    --                 ['cuivre'] = 35,
    --                 ['or'] = 10, 
    --                 ['diamant'] = 5, 
    --             }
    --         },
    --     },
    }
}