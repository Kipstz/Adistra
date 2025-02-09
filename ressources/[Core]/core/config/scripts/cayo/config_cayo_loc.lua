Config['cayo_loc'] = {
    MenuTitle = {
        MainMenu = "Locations",
        CategoryMenu = "Locations"
    },
    MenuSubTitle = {
        MainMenu = "Choissisez une catégorie",
        CategoryMenu = "Choissisez un véhicule"
    },

    localisations = {
        -- Cayo
        { 
            pos = vector3(4438.7, -4486.1, 4.2),
            categories = {
                { name = 'car', label = "Voitures", spawn = vector3(4441.2, -4496.6, 4.2), heading = -120.0 },
                { name = 'camions', label = "Camions", spawn = vector3(4441.2, -4496.6, 4.2), heading = -120.0 },
                { name = 'bike', label = "Motos", spawn = vector3(4441.2, -4496.6, 4.2), heading = -120.0 },
            },
        },
        { 
            pos = vector3(4931.5, -5146.3, 2.4),
            categories = {
                { name = 'boats', label = "Bateaux", spawn = vector3(4931.4, -5134.5, -0.4), heading = -120.0 },
            },
        },
        { 
            pos = vector3(4808.1, -4923.9, 2.0),
            categories = {
                { name = 'jetski', label = "Jet Ski", spawn = vector3(4796.2, -4933.9, -0.3), heading = -120.0 },
            },
        },
        { 
            pos = vector3(4426.3, -4481.2, 4.2),
            categories = {
                { name = 'helicos', label = "Hélicoptère", spawn = vector3(4419.8, -4517.3, 4.1), heading = -120.0 },
                { name = 'planes', label = "Avions", spawn = vector3(4419.8, -4517.3, 4.1), heading = -120.0 },
            },
        },

        -- LS

        { 
            pos = vector3(583.2, -3200.5, 6.0),
            categories = {
                { name = 'boats', label = "Bateaux", spawn = vector3(569.1, -3239.2, -0.4), heading = -120.0 },
            },
        },
        { 
            pos = vector3(585.6, -3203.7, 6.0),
            categories = {
                { name = 'jetski', label = "Jet Ski", spawn = vector3(569.1, -3239.2, -0.4), heading = -120.0 },
            },
        },
        { 
            pos = vector3(-1609.7, -3129.5, 15.5),
            categories = {
                { name = 'helicos', label = "Hélicoptère", spawn = vector3(-1652.6, -3142.5, 13.9), heading = -120.0 },
                { name = 'planes', label = "Avions", spawn = vector3(-1652.6, -3142.5, 13.9), heading = -120.0 },
            },
        },

        -- Sandy Shore

        { 
            pos = vector3(1770.9, 3237.8, 42.2),
            categories = {
                { name = 'helicos', label = "Hélicoptère", spawn = vector3(1770.9, 3237.8, 42.2), heading = -120.0 },
                { name = 'planes', label = "Avions", spawn = vector3(1711.1, 3250.7, 41.0), heading = -120.0 },
            },
        },

        -- Paleto 

        { 
            pos = vector3(2142.2, 4811.6, 41.1),
            categories = {
                { name = 'helicos', label = "Hélicoptère", spawn = vector3(2142.2, 4811.6, 41.1), heading = -120.0 },
                { name = 'planes', label = "Avions", spawn = vector3(2104.7, 4796.5, 41.0), heading = -120.0 },
            },
        },

        -- Space 

        { 
            pos = vector3(1234.8, -6915.6, 111.7),
            categories = {
                { name = 'space', label = "Vehicules Speciaux", spawn = vector3(1236.1854, -6911.8496, 111.7309), heading = 270.00 },
            },
        },
    },
    vehicles = {
        { cat = 'car', name = 'winky', label = "Winky", price = 2500 },

        { cat = 'camions', name = 'benson', label = "Benson", price = 4000 },
        { cat = 'camions', name = 'mule', label = "Mule 1", price = 4000 },
        { cat = 'camions', name = 'mule2', label = "Mule 2", price = 4000 },
        { cat = 'camions', name = 'mule3', label = "Mule 3", price = 4000 },
        { cat = 'camions', name = 'mule4', label = "Mule 4", price = 4000 },
        { cat = 'camions', name = 'pounder', label = "Pounder 1", price = 4000 },
        { cat = 'camions', name = 'pounder2', label = "Pounder 2", price = 4000 },

        { cat = 'bike', name = 'manchez2', label = "Manchez 2", price = 1500 },

        { cat = 'boats', name = 'dinghy3', label = "Dinghy 3", price = 3000 },
        { cat = 'boats', name = 'dinghy4', label = "Dinghy 4", price = 3000 },
        { cat = 'boats', name = 'jetmax', label = "Jet Max", price = 3000 },
        { cat = 'boats', name = 'marquis', label = "Marquis", price = 3000 },
        { cat = 'boats', name = 'speeder', label = "Speeder 1", price = 3000 },
        { cat = 'boats', name = 'speeder2', label = "Speeder 2", price = 3000 },
        { cat = 'boats', name = 'suntrap', label = "Sun Trap", price = 3000 },
        { cat = 'boats', name = 'toro', label = "Toro 1", price = 3000 },
        { cat = 'boats', name = 'toro2', label = "Toro 2", price = 3000 },
        { cat = 'boats', name = 'tropic', label = "Tropic 1", price = 3000 },
        { cat = 'boats', name = 'tropic2', label = "tropic 2", price = 3000 },
        { cat = 'boats', name = 'longfin', label = "longfin", price = 3000 },
        
        { cat = 'jetski', name = 'seashark', label = "Jet Ski 1", price = 1500 },
        { cat = 'jetski', name = 'seashark2', label = "Jet Ski 2", price = 1500 },
        { cat = 'jetski', name = 'seashark3', label = "Jet Ski 3", price = 1500 },
        
        { cat = 'helicos', name = 'frogger', label = "Frogger 1", price = 4000 },
        { cat = 'helicos', name = 'maverick', label = "Maverick", price = 4000 },
        { cat = 'helicos', name = 'havok', label = "Havok", price = 4000 },
        { cat = 'helicos', name = 'supervolito', label = "SuperVolito 1", price = 4000 },
        { cat = 'helicos', name = 'supervolito2', label = "SuperVolito 1", price = 4000 },
        { cat = 'helicos', name = 'volatus', label = "Volatus", price = 4000 },
        { cat = 'helicos', name = 'seasparrow', label = "SeaSparrow 1", price = 4000 },
        { cat = 'helicos', name = 'seasparrow2 ', label = "SeaSparrow 2", price = 4000 },
        { cat = 'helicos', name = 'seasparrow3 ', label = "SeaSparrow 3", price = 4000 },

        { cat = 'planes', name = 'duster', label = "Duster", price = 5000},
        { cat = 'planes', name = 'dodo', label = "Dodo", price = 5000},
        { cat = 'planes', name = 'cuban800', label = "Cuban 800", price = 5000},
        { cat = 'planes', name = 'howard', label = "Howard", price = 5000},
        { cat = 'planes', name = 'microlight', label = "MicroLight", price = 5000},
        { cat = 'planes', name = 'stunt', label = "Stunt", price = 5000},
        { cat = 'planes', name = 'velum2', label = "Velum 2", price = 5000},

        { cat = 'space', name = 'dune2', label = "Space Docker", price = 15000},
    },
    deleters = {
        pos = {

        },

        action = function()
            local plyPed = PlayerPedId()
            local inVeh = IsPedInAnyBoat(plyPed) or IsPedInAnyHeli(plyPed) or IsPedInAnyPlane(plyPed)

            if inVeh then
                local vehicle = GetVehiclePedIsIn(plyPed)

                Framework.Game.DeleteVehicle(vehicle)
            else
                Framework.ShowNotification("~r~Vous devez être dans un Véhicule !")
            end
        end
    },
}