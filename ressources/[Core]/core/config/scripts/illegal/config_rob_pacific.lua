Config['heist_pacific'] = {
    PoliceJobs = {
        'police', 'sheriff', 'fib', 'swat'
    },
    
    mincash = 950, -- minimum amount of cash a pile holds
    maxcash = 2000, -- maximum amount of cash a pile can hold
    black = true, -- enable this if you want blackmoney as a reward
    mincops = 7, -- minimum required cops to start mission
    enablesound = false, -- enables bank alarm sound
    lastrobbed = 0, -- don't change this
    cooldown = 1800, -- amount of time to do the heist again in seconds (30min)
    info = {stage = 0, style = nil, locked = false},
    totalcash = 0,
    PoliceDoors = {
        {loc = vector3(257.10, 220.30, 106.28), txtloc = vector3(257.10, 220.30, 106.28), model = "hei_v_ilev_bk_gate_pris", model2 = "hei_v_ilev_bk_gate_molten", obj = nil, obj2 = nil, locked = true},
        {loc = vector3(236.91, 227.50, 106.29), txtloc = vector3(236.91, 227.50, 106.29), model = "v_ilev_bk_door", model2 = "v_ilev_bk_door", obj = nil, obj2 = nil, locked = true},
        {loc = vector3(262.35, 223.00, 107.05), txtloc = vector3(262.35, 223.00, 107.05), model = "hei_v_ilev_bk_gate2_pris", model2 = "hei_v_ilev_bk_gate2_pris", obj = nil, obj2 = nil, locked = true},
        {loc = vector3(252.72, 220.95, 101.68), txtloc = vector3(252.72, 220.95, 101.68), model = "hei_v_ilev_bk_safegate_pris", model2 = "hei_v_ilev_bk_safegate_molten", obj = nil, obj2 = nil, locked = true},
        {loc = vector3(261.01, 215.01, 101.68), txtloc = vector3(261.01, 215.01, 101.68), model = "hei_v_ilev_bk_safegate_pris", model2 = "hei_v_ilev_bk_safegate_molten", obj = nil, obj2 = nil, locked = true},
        {loc = vector3(253.92, 224.56, 101.88), txtloc = vector3(253.92, 224.56, 101.88), model = "v_ilev_bk_vaultdoor", model2 = "v_ilev_bk_vaultdoor", obj = nil, obj2 = nil, locked = true}
    },

    doorchecks = {
        {x = 257.10, y = 220.30, z = 106.28, he = 339.733, h = GetHashKey("hei_v_ilev_bk_gate_pris"), h1 = "hei_v_ilev_bk_gate_pris", h2 = "hei_v_ilev_bk_gate_molten", status = 0},
        {x = 236.91, y = 227.50, z = 106.29, he = 340.000, h = GetHashKey("v_ilev_bk_door"), status = 0},
        {x = 262.35, y = 223.00, z = 107.05, he = 249.731, h = GetHashKey("hei_v_ilev_bk_gate2_pris"), status = 0},
        {x = 252.72, y = 220.95, z = 101.68, he = 160.278, h = GetHashKey("hei_v_ilev_bk_safegate_pris"), h1 = "hei_v_ilev_bk_safegate_pris", h2 = "hei_v_ilev_bk_safegate_molten", status = 0},
        {x = 261.01, y = 215.01, z = 101.68, he = 250.082, h = GetHashKey("hei_v_ilev_bk_safegate_pris"), h1 = "hei_v_ilev_bk_safegate_pris", h2 = "hei_v_ilev_bk_safegate_molten", status = 0},
        {x = 253.92, y = 224.56, z = 101.88, he = 160.000, h = GetHashKey("v_ilev_bk_vaultdoor"), status = 0,}
    },
    enablesupersilent = false, -- coming soon (or not)...
    enablextras = true, -- enable gold and diamond looting (yay!) [needs utk_ornateprops]
    disableinput = false, -- don't change anything else unless you know what you are doing
    hackfinish = false,
    initiator = false,
    stage0break = false,
    stage1break = false,
    stage2break = false,
    stage4break = false,
    stagelootbreak = false,
    startloot = false,
    grabber= false,
    loudstart = {x = 257.10, y = 220.30, z = 106.28, type = "hei_v_ilev_bk_gate_pris", h = 339.733},
    silentstart = {x = 236.91, y = 227.50, z = 106.29, type = "v_ilev_bk_door", h = 340.00},
    inside1 = {x = 252.72, y = 220.95, z = 101.68, type = "hei_v_ilev_bk_safegate_pris", h = 160.278},
    inside2 = {x = 261.01, y = 215.01, z = 101.68, h = 250.082},
    card1 = {x = 262.35, y = 223.00, z = 107.05},
    card2 = {x = 252.80, y = 228.55, z = 102.50},
    hack1 = {x = 262.35, y = 223.00, z = 107.05, type = "hei_v_ilev_bk_gate2_pris", h = 249.731},
    hack2 = {x = 252.80, y = 228.55, z = 102.50},
    vault = {x = 253.92, y = 224.56, z = 101.88, type = "v_ilev_bk_vaultdoor"},
    thermal1 = {x = 252.82, y = 221.07, z = 101.60},
    thermal2 = {x = 261.22, y = 215.43, z = 101.68},
    lockpick1 = {x = 252.82, y = 221.07, z = 101.60},
    lockpick2 = {x = 261.22, y = 215.43, z = 101.68},
    cash1 = {x = 257.40, y = 215.15, z = 101.68},
    cash2 = {x = 262.32, y = 213.31, z = 101.68},
    cash3 = {x = 263.54, y = 216.23, z = 101.68},
    gold = {x = 266.36, y = 215.31, z = 101.68},
    dia = {x = 265.11, y = 212.05, z = 101.68},
    cur = 7,
    starttimer = false,
    vaulttime = 0,
    searchlocations = {
        {coords = {x = 233.40, y = 221.53, z = 110.40}, status = false},
        {coords = {x = 240.93, y = 211.12, z = 110.40}, status = false},
        {coords = {x = 246.54, y = 208.86, z = 110.40}, status = false},
        {coords = {x = 264.33, y = 212.16, z = 110.40}, status = false},
        {coords = {x = 252.87, y = 222.36, z = 106.35}, status = false},
        {coords = {x = 249.71, y = 227.84, z = 106.35}, status = false},
        {coords = {x = 244.80, y = 229.70, z = 106.35}, status = false}
    },
    obj = {
        {x = 257.40, y = 215.15, z = 100.68, h = 269934519},
        {x = 262.32, y = 213.31, z = 100.68, h = 269934519},
        {x = 263.54, y = 216.23, z = 100.68, h = 269934519},
        {x = 266.36, y = 215.31, z = 100.68, h = 2007413986},
        {x = 265.11, y = 212.05, z = 100.68, h = 881130828}
    },
    emptyobjs = {
        {x = 257.40, y = 215.15, z = 100.68, h = 769923921},
        {x = 262.32, y = 213.31, z = 100.68, h = 769923921},
        {x = 263.54, y = 216.23, z = 100.68, h = 769923921},
        {x = 266.36, y = 215.31, z = 100.68, h = 2714348429},
        {x = 265.11, y = 212.05, z = 100.68, h = 2714348429}
    },
    checks = {
        hack1 = false,
        hack2 = false,
        thermal1 = false,
        thermal2 = false,
        id1 = false,
        id2 = false,
        idfound = false,
        grab1 = false,
        grab2 = false,
        grab3 = false,
        grab4 = false,
        grab5 = false
    },
    alarmblip,
    text = { -- Texts
        loudstart = "[~r~E~w~] Démarrer le braquage ~g~EN FORCE~w~",
        silentstart = "[~r~E~w~] Démarrer le braquage ~g~EN FURTIF~w~",
        usecard = "[~r~E~w~] Utiliser la carte d'identification",
        usethermal = "[~r~E~w~] Utiliser une charge thermique",
        usehack = "[~r~E~w~] Hack le panel de sécurité",
        uselockpick = "[~r~E~w~] Utiliser un Lockpick",
        usesearch = "[~r~E~w~] Rechercher",
        lootcash= "[~r~E~w~] Commencer à prendre de l'argent",
        lootgold = "[~r~E~w~] Commencer à prendre de l'or",
        lootdia = "[~r~E~w~] Commencer à prendre des diamants",
        card = "Utilisation de la carte d'identification",
        thermal = "Mise en place de la charge thermique",
        burning = "Fonte de la serrure",
        lockpick = "Crochetage de la serrure",
        using = "Traitement du panel",
        used = "Transaction effectué.",
        stage = "effectué.",
        search = "Recherche",
        hacking = "Hacking",
        melted = "Serrure de porte fondue.",
        hacked = "Hack terminé.",
        unlocked = "Porte déverouillé.",
        nothing = "Rien trouvé.",
        found = "Vous avez trouvé la carte d'identification.",
        time = "Restant: "
    }
}

Config['heist_pacific'].searchinfo = {
    random = math.random(1, Config['heist_pacific'].cur),
    found = false
}