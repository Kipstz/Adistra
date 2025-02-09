
Config['job_cayoems'] = {
    Points = {
        pharmacie = {
            pos = vector3(4500.3, -4529.2, 4.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à la Pharmacie",

            action = function()
                CayoEmsJob.OpenPharmacieMenu()
            end
        },
        vestiaire = {
            pos = vector3(4490.5, -4532.7, 4.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",

            action = function()
                CayoEmsJob.OpenVestiaireMenu()
            end
        },
        garage = {
            pos = vector3(4499.1, -4524.5, 4.4),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                CayoEmsJob.OpenGarageMenu()
            end
        },
        garage2 = {
            pos = vector3(4488.8, -4515.6, 5.7),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage Helicoptère",

            action = function()
                CayoEmsJob.OpenGarage2Menu()
            end
        },
        deleters = {
            pos = {
                vector3(4511.9, -4517.6, 4.1),
                vector3(4490.7, -4509.1, 5.7),
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
            pos = vector3(4491.6, -4528.4, 4.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'cayoems')
            end
        }
    },

    Tenues = {
        { label = "Médecin", skin = {
            m = {
                ['tshirt_1'] = 130,
                ['tshirt_2'] = 0,
                ['torso_1']  = 460,
                ['torso_2']  = 0,
                ['decals_1'] = 72,
                ['decals_2'] = 0,
                ['arms']     = 35,
                ['pants_1']  = 10,
                ['pants_2']  = 7,
                ['shoes_1']  = 163,
                ['shoes_2']  = 0,
                ['helmet_1'] = 160,
            },
            f = {
                ['tshirt_1'] = 9,
                ['tshirt_2'] = 0,
                ['torso_1']  = 196,
                ['torso_2']  = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms']     = 75,
                ['pants_1']  = 135,
                ['pants_2']  = 0,
                ['shoes_1']  = 164,
                ['shoes_2']  = 0,
                ['helmet_1'] = 137,
            }
        }},
    },

    Sacs = {
        { label = "Sac N°1", skin = {
            m = {
                ['bags_1'] = 75,
                ['bags_2'] = 0
            }, 
            f = {
                ['bags_1'] = 22,
                ['bags_2'] = 12
            }, 
        }},
    },
    
    Garage = {
        SpawnPos = vector3(4511.9, -4517.6, 4.1),
        SpawnHeading = -130.91,

        Categories = {
            { minGrade = 0, name = 'pnj',    label = "Véhicules De Base" },
            { minGrade = 0, name = 'base',    label = "Véhicules Modif" },
            { minGrade = 0, name = 'hg',    label = "Véhicules HG" },
        },

        Vehicules = {
            { categorie = 'pnj', minGrade = 0, model = 'ambulance', label = "Ambulance 1"},
            { categorie = 'pnj', minGrade = 0, model = 'ambulance2', label = "Ambulance 2"},

            { categorie = 'hg', minGrade = 2, model = 'aleutianems', label = "Aleutian"},
            { categorie = 'hg', minGrade = 3, model = 'emsscout', label = "Vapid Scout"},

            { categorie = 'base', minGrade = 1, model = 'dw_ambulance', label = "Ambulance 1"},
            { categorie = 'base', minGrade = 1, model = 'dw_ambulance2', label = "Ambulance 2"},
            { categorie = 'base', minGrade = 1, model = 'dw_emscar', label = "EMS Voiture 1"},
            { categorie = 'base', minGrade = 1, model = 'dw_emscar2', label = "EMS Voiture 2"},
            { categorie = 'base', minGrade = 1, model = 'dw_emssuv', label = "EMS SUV"},
            { categorie = 'base', minGrade = 1, model = 'dw_emsvan', label = "EMS Van"},
            -- { categorie = 'base', minGrade = 0, model = 'ems6', label = "EMS Bateau"},

        }
    },

    Garage2 = {
        SpawnPos = vector3(4490.7, -4509.1, 5.7),
        SpawnHeading = 95.91,

        Categories = {
            { minGrade = 1, name = 'helico', label = "Helicoptères" }
        },

        Helicos = {
            { categorie = 'helico', minGrade = 1, model = 'aw109', label = "Hélicoptère"},
        }
    },

    ReviveReward = 1000
}