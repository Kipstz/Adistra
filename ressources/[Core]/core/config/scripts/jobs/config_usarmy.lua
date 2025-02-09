
Config['job_usarmy'] = {
    Stations = {
        --Vespucci = {
        --    vestiaire = {
        --        pos = vector3(-1831.9, 3220.0, 32.9),
        --        msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Vestiaire",
        --
        --        action = function()
        --            UsArmyJob.OpenVestiaireMenu()
        --        end
        --    },
            armurerie = {
                pos = vector3(-1835.2, 3225.1, 32.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder à l'armurerie ",

                action = function()
                    UsArmyJob.OpenArmurerieMenu()
                end
            },
            garage = {
                pos = vector3(-1836.4, 3006.4, 32.8),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage",

                action = function()
                    UsArmyJob.OpenGarageMenu()
                end
            },
            garage2 = {
                pos = vector3(-1830.9, 3003.4, 32.8),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Garage Helicoptère",

                action = function()
                    UsArmyJob.OpenGarage2Menu()
                end
            },
            deleters = {
                pos = {
                    vector3(-1840.5, 2988.2, 32.8),
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
                pos = vector3(-1828.3, 3245.3, 32.9),
                msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

                action = function()
                    -- WL grades non obligatoire, access to boss actions & remove items on coffre --
                    local wlGrades = {'boss'}
                    TriggerEvent('bossManagement:openMenu', 'usarmy', wlGrades)
                end
            }
        --}
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
        SpawnPos = vector3(-1840.5, 2988.2, 32.8),
        SpawnHeading = -130.91,

        Categories = {
            { minGrade = 0, name = 'base', label = "Véhicules" },
        },

        Vehicules = {
            { categorie = 'base', minGrade = 0, model = 'abrams', label = "Abrams"},
            { categorie = 'base', minGrade = 0, model = 'abrams2', label = "Abrams 2"},
            { categorie = 'base', minGrade = 0, model = 'brad', label = "Brad"},
            { categorie = 'base', minGrade = 0, model = 'brad2', label = "Brad 2"},
            { categorie = 'base', minGrade = 0, model = 'bspec', label = "Bspec"},
            { categorie = 'base', minGrade = 0, model = 'hasrad', label = "Hasrad"},
            { categorie = 'base', minGrade = 0, model = 'hmvs', label = "Hmvs"},
            { categorie = 'base', minGrade = 0, model = 'lav25ifv', label = "Lav25ifv"},
            { categorie = 'base', minGrade = 0, model = 'lavadadv', label = "Rlavadadvump"},
            { categorie = 'base', minGrade = 0, model = 'm142as', label = "M142as"},
            { categorie = 'base', minGrade = 0, model = 'm1128s', label = "M1128s"},
            { categorie = 'base', minGrade = 0, model = 'mrap', label = "Mrap"},
            { categorie = 'base', minGrade = 0, model = 'unarmed1', label = "Unarmed"},
            { categorie = 'base', minGrade = 0, model = 'unarmed2', label = "Unarmed 2"},
            { categorie = 'base', minGrade = 0, model = 'uparmor', label = "Uparmor"},
            { categorie = 'base', minGrade = 0, model = 'uparmorw', label = "Uparmorw"},
            { categorie = 'base', minGrade = 0, model = 'crusader', label = "Crusader"},
            { categorie = 'base', minGrade = 0, model = 'barracks', label = "Barracks"},
            { categorie = 'base', minGrade = 0, model = 'barracks2', label = "Barracks 2"},
            { categorie = 'base', minGrade = 0, model = 'barracks3', label = "Barracks 3"},
            { categorie = 'base', minGrade = 0, model = 'barrage', label = "Barrage"},
        }
    },

    Garage2 = {
        SpawnPos = vector3(-1840.5, 2988.2, 32.8),
        SpawnHeading = 95.91,

        Categories = {
            { minGrade = 6, name = 'avions', label = "Helicos / Avions" }
        },

        Helicos = {
            { categorie = 'avions', minGrade = 0, model = 'strikeforce', label = "Strikeforce"},
            { categorie = 'avions', minGrade = 0, model = 'valkyrie', label = "Valkyrie"},
            { categorie = 'avions', minGrade = 0, model = 'valkyrie2', label = "Valkyrie 2"},
            { categorie = 'avions', minGrade = 0, model = 'cargobob', label = "Cargobob 1"},
            { categorie = 'avions', minGrade = 0, model = 'cargobob2', label = "Cargobob 2"},
            { categorie = 'avions', minGrade = 0, model = 'cargobob3', label = "Cargobob 3"},
            { categorie = 'avions', minGrade = 0, model = 'cargobob4', label = "Cargobob 4"},
            { categorie = 'avions', minGrade = 0, model = 'annihilator2', label = "Annihilator 2"},
            { categorie = 'avions', minGrade = 0, model = 'skylift', label = "Skylift"},
            { categorie = 'avions', minGrade = 0, model = 'hydra', label = "Hydra"},
            { categorie = 'avions', minGrade = 0, model = 'lazer', label = "Lazer"},
            { categorie = 'avions', minGrade = 0, model = 'bombushka', label = "Bombushka"},
            { categorie = 'avions', minGrade = 0, model = 'besra', label = "Besra"},
            { categorie = 'avions', minGrade = 0, model = 'avenger', label = "Avenger"},
            { categorie = 'avions', minGrade = 0, model = 'titan', label = "Titan"},
            { categorie = 'avions', minGrade = 0, model = 'tula', label = "Tula"},
            { categorie = 'avions', minGrade = 0, model = 'miljet', label = "Miljet"},
            { categorie = 'avions', minGrade = 0, model = 'molotok', label = "Molotok"},
        }
    },
}