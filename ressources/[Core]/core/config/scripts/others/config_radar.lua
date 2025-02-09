Config['radar'] = {

    priceL1 = 250,
    priceL2 = 500,
    priceL3 = 750,
    priceL4 = 1000,

    BypassJob = {
        -- mettre tout les métier qui ne prendront pas d'amende si ils sont flashés !
        "police",
        "ambulance",
        "sheriff",  
        "cayoambulance",
        "cayoems",
        "gouvernement",
    },

    zones = {
        {
            position = { x = 398.12, y = -1050.50, z = 29.39 },
            speedlimit = 130,
            radius = 35
        },
        {
            position = { x = -270.35, y = -1139.82, z = 23.09 },
            speedlimit = 130,
            radius = 40
        },
        {
            position = { x = -251.45, y = -661.61, z = 33.25 },
            speedlimit = 130,
            radius = 40
        },
        {
            position = { x = 169.67, y = -819.68, z = 31.17 },
            speedlimit = 130,
            radius = 40
        },
        {
            position = { x = 1613.86, y = 1122.46, z = 82.66 },
            speedlimit = 250,
            radius = 40
        },
        {
            position = { x = -2318.29, y = -322.42, z = 13.79 },
            speedlimit = 250,
            radius = 40
        },
        {
            position = { x = 2431.51, y = -177.62, z = 87.96 },
            speedlimit = 250,
            radius = 40
        },
        {
            position = { x = 785.25, y = -29.38, z = 80.64 },
            speedlimit = 130,
            radius = 40
        },
        {
            position = { x = 641.23, y = -211.31, z = 44.19 },
            speedlimit = 130,
            radius = 40
        },
        {
            position = { x = 394.63, y = -570.22, z = 28.68 },
            speedlimit = 130,
            radius = 60
        },
        {
            position = { x = -79.77, y = -1152.05, z = 25.75 },
            speedlimit = 130,
            radius = 60
        },
        {
            position = { x = -25.32, y = -973.42, z = 29.37 },
            speedlimit = 130,
            radius = 70
        },
        {
            position = { x = -373.48, y = -855.49, z = 31.60 },
            speedlimit = 130,
            radius = 70
        },
        {
            position = { x = 411.04, y = -1060.61, z = 29.42 },
            speedlimit = 150,
            radius = 70
        },
    }

}