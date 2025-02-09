Config['zonesafe'] = {
    localisations = {
        {pos = vector3(-413.2, 1168.3, 325.9), radius = 50.0}, -- Spawn
        {pos = vector3(218.76, -802.87, 30.09), radius = 80.0}, -- Central car park
        {pos = vector3(-386.8, -349.3, 32.3), radius = 70.0}, -- Police station
        {pos = vector3(317.6, -593.6, 44.0), radius = 80.0}, -- Hospital
        {pos = vector3(-38.22, -1100.84, 26.42), radius = 50.0}, -- Car dealer
        {pos = vector3(-373.6, -121.8, 38.7), radius = 80.0}, -- Mécano
        {pos = vector3(-211.34, -1322.06, 30.89), radius = 80.0}, -- Benny's
        {pos = vector3(118.6, -1289.5, 28.4), radius = 100.0}, -- Unicorn
        {pos = vector3(246.8, -3177.3, -0.7), radius = 120.0}, -- 77-Club
        {pos = vector3(-438.7, -30.9, 46.2), radius = 100.0}, -- Hookah-Chicha
        {pos = vector3(-1389.8, -584.5, 30.2), radius = 100.0}, -- Bahama Mamas
        {pos = vector3(581.4, -2805.9, 6.0), radius = 100.0}, -- SWAT
        {pos = vector3(2517.9, -358.5, 94.1), radius = 100.0}, -- FIB
        {pos = vector3(-781.34912109375,336.51940917969,208.60813903809), radius = 10.0}, -- ZONE SAFE
    },
    disabledKeys = {
        {group = 2, key = 37},
        {group = 0, key = 24},
        {group = 0, key = 69},
        {group = 0, key = 80},
        {group = 0, key = 92},
        {group = 0, key = 106},
        {group = 0, key = 140},
        {group = 0, key = 168}
    },
    wlJobs = {
        'police',
        'sheriff',
        'sheriffpaleto',
        'usarmy',
        'swat',
        'gouvernement',
        'fib',
        'unicorn',
        'bahama',
        '77club',
        'hookah'
    }
}