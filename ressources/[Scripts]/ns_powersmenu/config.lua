
Config = {}

Config.perm = {
    'license:d81a93b210ba965c5015e8a70f92aaf4bd9c1b4d', -- KABYLE
    'license:0cac145e858bd1fea456b608407456d6e044a8a8', -- YUTO
    'license:20ef97fcfefc7c9b4549fceec8c51d9d5c076164', -- OMRI
}

Config.UsePerm = true -- Use permission system or not

Config.GetId = true -- If you don't know your id or the players id, if this is set to true, you can do the /getId command and /copyId [id number] for getting it ⚠ this can show the ip adress of the player ! ⚠

--- Super kick ---

Config.SuperKickPower = 10 -- The power of super kick

--- Fly ---

Config.AddPowerEveryFrameValue = 0.05 -- This is the value of power to add every frame when charging fly

Config.SpeedDivider = 2 -- When set to 2, when releasing the move key in fly mode, it divide the speed by 2, sety this to 1 if you don't want this

Config.DefaultPower = 50 -- The power starts to 50 when charging

--- Laser sight ---

Config.LaserShootKey = 38 -- [E] by default, keybind for shoot lasers

--- Explosions ---

Config.AccExplKey = 38 -- [E] by default, it's the key for explose in accurate mode

Config.AccColor = {red = 255, green = 255, blue = 255, opacity = 255} -- Color of "crosshair in accurate mode" each value from 0 to 255

Config.ThrowFireballKey = 47 -- [G] by default, it's the key for throw a fire ball in thrower mode

Config.OtherExplKey = 38 -- [E] by default, it's the key for explose in all other modes

----- Strangulation -----

Config.StrangAnimDict = "stungun@standing" -- The main animation dict

Config.StrangAnim     = "damage" -- The main animation name

Config.StranghandBone       = "IK_L_Hand" -- The bone to attach the player

Config.StrangDeathAnimDict  = "mp_sleep" -- The death animation dict

Config.StrangDeathAnim      = "sleep_loop" -- The death animation name

Config.StrangKillKey        = 74 -- H ( The key for kill the player while strangulate )

Config.StrangGrabKey        = 29 -- B ( For this key, set the key to point in your server, in most of case it's B. There's many resources that allow pointing on FiveM like dpemotes )

Config.StrangParticleDict   = "core" -- The blood particle dict

Config.StrangParticle       = "ent_sht_blood" -- The blood particle name

Config.StrangbloodBone      = "IK_Head" -- The bone where the blood will be attached

Config.StrangwaitTime       = 2000 -- The time to wait between you press the kill key and the anim death start

Config.StranghelpNotif      = '~r~Appuyez sur ~INPUT_VEH_HEADLIGHT~ pour tuer la personne ~w~' -- The text showed in help notification

Config.StranghelpNotif2     = '~g~Appuyez sur ~INPUT_SPECIAL_ABILITY_SECONDARY~ pour la relacher' -- The text showed in second line of help notification ( set to nil if you don't want it )

Config.StranghelpNotif3     = nil -- The text showed in third line of help notification ( set to nil if you don't want it )

Config.StranghelpNotifD     = '~r~Vous avez tué la personne ! ~w~' -- The text showed in help notification after death

Config.StranghelpNotifD2    = '~g~Appuyez sur ~INPUT_SPECIAL_ABILITY_SECONDARY~ pour lacher le corps !' -- The text showed in second line of help notification after death ( set to nil if you don't want it )

Config.StranghelpNotifD3    = nil -- The text showed in third line of help notification after death ( set to nil if you don't want it )

Config.StrangDeathNotify    = 'Coup broyé !' -- The text showed in the notification after death

Config.StrangActivateNotify = 'Etranglement activé !' -- The text showed in the notification when you turn on the strangulation

Config.StrangDisableNotify  = 'Etranglement désactivé !' -- The text showed in the notification when you turn off the strangulation

Config.StrangNotify  = 'étranglement en cours !' -- The text showed in the notification when you start an strangulation

Config.StrangNoCloseNotify  = 'Personne à coté de vous !' -- The text showed in the notification to say that nobody is close to you

Config.StrangCancelNotify   = 'Etranglement annulé !' -- The text showed in the notification when you cancel the strangulation

--- functions ---

function pwPermCheck() -- possibility to change the permission system, do what you want or keep default
    
    local hasPerm = lib.callback.await('PW2:checkPerm', false)

    if Config.UsePerm then
        if hasPerm then
        
            return true -- this for say to script the player has the perm
    
        else
    
            return false -- this for say to script the player doesn't have the perm
    
        end
    else
        return true -- this for say to script the player has the perm
    end

end

--- Languages ---

Config.lang = 'fr'

Config.Languages = {
    {
        id = 'fr',
        name = 'Français',

        activate = 'Activation',

        commandname = 'Ouvrir le powers menu',
        
        -- HULK --
        hulkLabel = 'Pouvoirs de Hulk',
        hulkDesc = 'Devenez Hulk !',

        -- Misc powers --

        misc = 'Divers',
        miscLabel = 'Pouvoirs divers',
        miscDesc = 'Plusieurs pouvoirs que vous pouvez activer séparement',

        trail = 'Trainée',
        laser = 'Yeux laser',
        superspeed = 'Super vitesse',
        fly = 'Vol',
        proofs = 'Résistances',
        noragdoll = 'Ne tombe jamais',
        superkick = 'Super force',
        strangulation = 'Étranglement',
        explosion = { title = 'Explosions', none = 'Aucun', acc = 'Précis', circle = 'Cercle', loop = 'En boucle', loop2 = 'En boucle 2', loop3 = 'En boucle 3', loop4 = 'En boucle 4', random = 'Aléatoire', thrower = 'Lancer' },
        rageLabel = 'Rage',
        force = 'Force',
        forcefield = 'Champ de force',
        wow = 'Marcher sur l\'eau',

        -- Proofs --

        bulletproof = 'Résistance aux balles',
        fireproof = 'Résistance au feu',
        exploproof = 'Résistance au explosions',
        colproof = 'Résistance aux collisions',
        meleeproof = 'Résistance aux coups',
        steamproof = 'Résistance aux fumées',
        drownproof = 'Résistance à la noyade',

        -- Trail --

        lightning = 'Éclairs',
        fire = 'Feu',
        color = 'Couleur',
        isRandom = 'Aléatoire ?',
        opacity = 'Opacité',
        opacityDesc = 'De 0 à 10',

        -- Settings --

        settings = 'Paramètres',

        slowTakeoff = 'Atterissage/Décollage lent',

        changeSSvelocity = 'Changer la vitesse de la super vitesse',

        velocity = 'Vitesse',

        -- Fly --

        flySelf = 'Moi',
        flyVeh = 'Vehicule',

        rage = { orange = 'Orange', blue = 'Bleu', red = 'Rouge', white = 'Blanc' },
    },
    {
        id = 'en',
        name = 'English',

        activate = 'Activate',

        commandname = 'Open the powers menu',
        
        -- HULK --
        hulkLabel = 'Hulk powers',
        hulkDesc = 'Become Hulk !',

        -- Misc powers --

        misc = 'Misc',
        miscLabel = 'Misc powers',
        miscDesc = 'Multiple powers that you can activate',

        trail = 'Trail',
        laser = 'Laser sight',
        superspeed = 'Super speed',
        fly = 'Fly',
        proofs = 'Proofs',
        noragdoll = 'No ragdoll',
        superkick = 'Super kick',
        strangulation = 'Strangulate',
        explosion = { title = 'Explosions', none = 'None', acc = 'Accurate', circle = 'Circle', loop = 'Loop', loop2 = 'Loop 2', loop3 = 'Loop 3', loop4 = 'Loop 4', random = 'Random', thrower = 'Thrower' },
        rageLabel = 'Rage',
        force = 'Force',
        forcefield = 'Force field',
        wow = 'Walking over water',

        -- Proofs --

        bulletproof = 'Bullet proof',
        fireproof = 'Fire proof',
        exploproof = 'Explosion proof',
        colproof = 'Collision proof',
        meleeproof = 'Melee proof',
        steamproof = 'Steam proof',
        drownproof = 'Drown proof',

        -- Trail --

        lightning = 'Lightning',
        fire = 'Fire',
        color = 'Color',
        isRandom = 'Random ?',
        opacity = 'Opacity',
        opacityDesc = 'From 0 to 10',

        -- Settings --

        settings = 'Settings',

        slowTakeoff = 'Slow takeoff/landing',

        changeSSvelocity = 'Change superspeed velocity',

        velocity = 'Velocity',

        -- Fly --

        flySelf = 'Self',
        flyVeh = 'Vehicle',

        rage = { orange = 'orange', blue = 'blue', red = 'red', white = 'white' },
    },
}