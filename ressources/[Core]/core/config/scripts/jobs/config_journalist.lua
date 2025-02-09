Config['job_journalist'] = {
    Points = {
        garage = {
            pos = vector3(-537.1, -888.1, 25.1),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

            action = function()
                JournalisteJob.OpenGarageMenu()
            end
        },
        deleters = {
            pos = {
                vector3(-543.9, -899.6, 23.9),
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
            pos = vector3(-582.8, -928.6, 28.2),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'journalist')
            end
        }
    },

    Garage = {
        SpawnPos = vector3(-543.9, -899.6, 23.9),
        SpawnHeading = 90.0,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'rumpo', label = "Rumpo"},
        }
    },
}