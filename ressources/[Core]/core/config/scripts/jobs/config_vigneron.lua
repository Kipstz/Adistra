Config['job_vigneron'] = {
    Points = {
        garage = {
            pos = vector3(-1928.2, 2060.4, 140.8),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                VigneronJob.OpenGarageMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-1922.1, 2044.7, 140.7),
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
            pos = vector3(-1909.04, 2072.11, 140.39),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'vigneron')
            end
        },
        harvest = {
            pos = vector3(-1894.6, 2143.7, 121.5),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à la récolte",

            action = function()
                VigneronJob.OpenHarvestMenu()
            end
        },
        craft = {
            pos = vector3(-50.7, 1911.0, 195.5),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Traitement",

            action = function()
                VigneronJob.OpenCraftMenu()
            end
        },
        sell = {
            pos = vector3(2551.4, 347.7, 108.6),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à la Vente",

            action = function()
                VigneronJob.OpenSellMenu()
            end
        },
    },

    Garage = {
        SpawnPos = vector3(-1922.1, 2044.7, 140.7),
        SpawnHeading = 0.0,

        Categories = {
            { minGrade = 0, name = 'base',    label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'speedo', label = "speedo"},

        }
    },

    itemsHarvest = {
        { name = 'raisin', label = "Raisins", msg = "Récolte de Raisins" },
    },
    itemsCraft = {
        { need = 'raisin', name = 'champ', label = "Champagne", msg = "Fabrication de Champagne" },
    },
    itemsSell = {
        { need = 'champ', label = "Champagne", msg = "Vente de Champagne" },
    },

    sellPrice = 450,
}