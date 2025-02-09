Config['drugs'] = {

    -- LS --

    ['weed'] = {
        harvest = {
            pos = vector3(2193.3, 5594.4, 53.7),
            item = 'weed',
            msg = "~INPUT_CONTEXT~ pour commencer a récolter",
            progressMsg = "Récolte en cours...",
            action = function()
                Drugs.startHarvest('weed')
            end
        },
        craft = {
            pos = vector3(1983.7158203125, 5175.8662109375, 47.639141082764),
            need = 'weed',
            item = 'weed_pooch',
            msg = "~INPUT_CONTEXT~ pour commencer a traiter",
            progressMsg = "Traitement en cours...",
            action = function()
                Drugs.startCraft('weed')
            end
        },
        sell = {
            pos = vector3(1636.9, 4838.7, 41.9),
            need = 'weed_pooch',
            price = 900,
            msg = "~INPUT_CONTEXT~ pour commencer a vendre",
            progressMsg = "Vente en cours...",
            pedModel = 'g_m_y_salvaboss_01',
            pedHeading = 90.0,
            action = function()
                Drugs.startSell('weed')
            end
        }
    },

    ['opium'] = {
        harvest = {
            pos = vector3(1903.9, 4926.8, 48.9),
            item = 'opium',
            msg = "~INPUT_CONTEXT~ pour commencer a récolter",
            progressMsg = "Récolte en cours...",
            action = function()
                Drugs.startHarvest('opium')
            end
        },
        craft = {
            pos = vector3(2589.6, 4677.8, 34.0),
            need = 'opium',
            item = 'opium_pooch',
            msg = "~INPUT_CONTEXT~ pour commencer a traiter",
            progressMsg = "Traitement en cours...",
            action = function()
                Drugs.startCraft('opium')
            end
        },
        sell = {
            pos = vector3(2522.2, 4112.5, 38.6),
            need = 'opium_pooch',
            price = 1100,
            msg = "~INPUT_CONTEXT~ pour commencer a vendre",
            progressMsg = "Vente en cours...",
            pedModel = 'g_m_y_salvaboss_01',
            pedHeading = 90.0,
            action = function()
                Drugs.startSell('opium')
            end
        }
    },

    ['coke'] = {
        harvest = {
            pos = vector3(1014.6, -2892.7, 15.2),
            item = 'coke',
            msg = "~INPUT_CONTEXT~ pour commencer a récolter Coke",
            progressMsg = "Récolte en cours...",
            action = function()
                Drugs.startHarvest('coke')
            end
        },
        craft = {
            pos = vector3(1755.4, -1650.1, 112.6),
            need = 'coke',
            item = 'coke_pooch',
            msg = "~INPUT_CONTEXT~ pour commencer a traiter Coke",
            progressMsg = "Traitement en cours...",
            action = function()
                Drugs.startCraft('coke')
            end
        },
        sell = {
            pos = vector3(989.7, -1665.6, 37.1),
            need = 'coke_pooch',
            price = 1250,
            msg = "~INPUT_CONTEXT~ pour commencer a vendre Coke",
            progressMsg = "Vente en cours...",
            pedModel = 'g_m_y_salvaboss_01',
            pedHeading = 90.0,
            action = function()
                Drugs.startSell('coke')
            end
        }
    },

    -- CAYO --

    ['adiskush'] = {
        harvest = {
            pos = vector3(5314.67, -5285.59, 33.96),
            item = 'adiskush',
            msg = "~INPUT_CONTEXT~ pour commencer a récolter Adiskush",
            progressMsg = "Récolte en cours...",
            action = function()
                Drugs.startHarvest('adiskush')
            end
        },
        craft = {
            pos = vector3(5065.06, -4590.85, 2.86),
            need = 'adiskush',
            item = 'adiskush_pooch',
            msg = "~INPUT_CONTEXT~ pour commencer a traiter Adiskush",
            progressMsg = "Traitement en cours...",
            action = function()
                Drugs.startCraft('adiskush')
            end
        },
        sell = {
            pos = vector3(5494.96, -5835.27, 19.36),
            need = 'adiskush_pooch',
            price = 1400,
            msg = "~INPUT_CONTEXT~ pour commencer a vendre AdisKush",
            progressMsg = "Vente en cours...",
            pedModel = 'g_m_y_salvaboss_01',
            pedHeading = 90.0,
            action = function()
                Drugs.startSell('adiskush')
            end
        }
    },

}