YveltConfigGF = {}

YveltConfigGF.key = 'H' -- Key for open ranking menu
YveltConfigGF.zoneGF = {
    centre = vec3(1471.7595214844,6343.3979492188,0.0), -- The center of the circle
    rayon = 175.0, -- The radius of the circle
    exit = vec3(215.9952545166,-809.99523925781,30.729591369629), -- Position when leaving the gunfight zone
    exitHeading = 0.0, -- Heading when leaving the gunfight zone
    invincibleTime = 3000, -- Invincibility time on respawn
    antiSpamGunfight = 1500, -- Dont touch this, antispam (min : 1000)
    reward = 10, -- Amount of reward for a kill
    respawnTime = 1500,--3000, -- Respawn time
}

YveltConfigGF.SpawnPos = { -- Config spawn points (MIN : 1)
    {
        pos = vec3(1471.7595214844,6343.3979492188,22.37380027771),
        heading = 0.0,
    },
    {
        pos = vec3(1417.2318115234,6330.962890625,23.844535827637),
        heading = 0.0,
    },
    {
        pos = vec3(1553.4503173828,6331.2163085938,24.077346801758),
        heading = 40.0,
    },

    {
        pos = vec3(1513.6416015625,6316.1899414062,24.082731246948),
        heading = 40.0,
    }
}

