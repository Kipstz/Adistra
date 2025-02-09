Config['rob_houses'] = {
    localisations = {
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1229.2, -725.4, 60.8) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1222.3, -697.2, 60.8) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1221.3, -668.7, 63.5) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1206.9, -620.4, 66.4) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1203.4, -599.1, 68.1) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1200.6, -576.0, 69.1) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1204.1, -557.4, 69.4) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1242.3, -566.0, 69.7) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(1302.8, -527.9, 71.5) },
        { robbed = false, int = 'basgamme', job = 'police', pos = vector3(861.8, -582.8, 58.1) },

        { robbed = false, int = 'm_appart', job = 'police', pos = vector3(929.1, -639.5, 58.2) },
        { robbed = false, int = 'm_appart', job = 'police', pos = vector3(960.9, -669.4, 58.4) },
        { robbed = false, int = 'm_appart', job = 'police', pos = vector3(970.9, -700.8, 58.5) },
        { robbed = false, int = 'm_appart', job = 'police', pos = vector3(979.7, -715.6, 58.0) },
        { robbed = false, int = 'm_appart', job = 'police', pos = vector3(997.5, -729.1, 57.8) },

        { robbed = false, int = 'h_gamme', job = 'police', pos = vector3(-538.1, 478.1, 103.2) },
        { robbed = false, int = 'h_gamme', job = 'police', pos = vector3(-517.4, 432.6, 97.8) },
        { robbed = false, int = 'h_gamme', job = 'police', pos = vector3(-452.0, 395.7, 104.8) },
        { robbed = false, int = 'h_gamme', job = 'police', pos = vector3(-214.4, 400.4, 111.1) },

        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(-379.9, 6253.4, 31.8) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(-360.1, 6260.9, 31.9) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(-346.9, 6224.7, 31.7) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(-367.1, 6213.7, 31.8) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(-384.6, 6193.8, 31.5) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(-272.2, 6400.3, 31.3) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(1846.1, 3914.3, 33.5) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(1729.0, 3851.4, 34.8) },
        { robbed = false, int = 'motel', job = 'sheriff', pos = vector3(1639.2, 3731.6, 35.1) },
        -- { int = 'hautgamme', job = 'sheriff', pos = vector3() },
    },
    interieurs = {
        ['motel'] = {
            insidePos = vector3(151.09, -1007.80, -98.99),
            loots = {
                vector3(151.9, -1001.6, -99.0),
                vector3(153.9, -1000.8, -99.0),
                vector3(153.9, -1003.1, -99.0),
                vector3(151.4, -1003.8, -99.0),
                vector3(154.1, -1006.1, -99.0)
            },
            items = {
                [1] = {
                    'livres', 'dvd', 'collier', 'horloge', 'montre',
                },
                [2] = {
                    'bijoux', 'bague', 'tablette', 'ps4', 'xbox', 'laptop', 'airpod', 'smartphone'
                },
                [3] = {
                    'ecranplat', 'ps5',
                },
            }
        },
        ['basgamme'] = {
            insidePos = vector3(266.1, -1007.4, -101.0),
            loots = {
                vector3(265.8, -999.1, -99.0),
                vector3(261.9, -999.8, -99.0),
                vector3(259.8, -1003.7, -99.0),
                vector3(262.1, -1002.8, -99.0),
                vector3(257.0, -996.1, -99.0),
                vector3(261.9, -995.6, -99.0)
            },
            items = {
                [1] = {
                    'livres', 'dvd', 'collier', 'horloge', 'montre',
                },
                [2] = {
                    'bijoux', 'bague', 'tablette', 'ps4', 'xbox', 'laptop', 'airpod', 'smartphone'
                },
                [3] = {
                    'ecranplat', 'ps5', 'iphone15',
                },
            }
        },
        ['m_appart'] = {
            insidePos = vector3(346.6, -1012.3, -99.2),
            loots = {
                vector3(351.9, -998.6, -99.2),
                vector3(350.2, -999.2, -99.2),
                vector3(350.8, -993.9, -99.2),
                vector3(345.0, -996.5, -99.2),
                vector3(344.9, -994.0, -99.2),
                vector3(341.4, -997.3, -99.2),
                vector3(338.5, -996.7, -99.2),
                vector3(338.2, -1000.7, -99.2),
                vector3(340.6, -1003.4, -99.2),
                vector3(339.0, -1003.3, -99.2)
            },
            items = {
                [1] = {
                    'livres', 'dvd', 'collier', 'horloge', 'montre',
                },
                [2] = {
                    'bijoux', 'bague', 'tablette', 'ps4', 'xbox', 'laptop', 'airpod', 'smartphone'
                },
                [3] = {
                    'ecranplat', 'ps5', 'iphone15', 'rolex',
                },
            }
        },
        ['h_gamme'] = {
            insidePos = vector3(-682.0, 592.3, 145.4),
            loots = {
                vector3(-677.3, 593.6, 145.4),
                vector3(-668.5, 588.4, 145.2),
                vector3(-665.8, 585.2, 145.0),
                vector3(-671.6, 581.6, 145.0),
                vector3(-674.1, 585.0, 145.2),
                vector3(-671.4, 580.8, 141.6),
                vector3(-671.6, 587.2, 141.6),
                vector3(-664.6, 584.7, 141.6),
                vector3(-666.9, 587.2, 141.6),
                vector3(-682.2, 595.6, 137.8),
                vector3(-680.3, 588.9, 137.8),
                vector3(-680.8, 587.0, 137.8),
                vector3(-679.0, 585.5, 137.8),
                vector3(-675.4, 589.2, 137.8),
                vector3(-677.1, 591.0, 137.8),
            },
            items = {
                [1] = {
                    'livres', 'dvd', 'collier', 'horloge', 'montre',
                },
                [2] = {
                    'bijoux', 'bague', 'tablette', 'ps4', 'xbox', 'laptop', 'airpod', 'smartphone'
                },
                [3] = {
                    'ecranplat', 'ps5', 'iphone15', 'rolex', 
                },
            }
        },
    },
    requiredCops = 4,
    itemRequired = 'lockpick',
    cooldown = {hour = 0, minute = 30, second = 0}
}