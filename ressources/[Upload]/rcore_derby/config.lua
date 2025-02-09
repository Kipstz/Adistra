Config = {}

Config.Framework = {
    -- 0 = standalone
    -- 1 = esx
    -- 2 = qbcore
    Active = 0,

    -- esx
    ESX_SHARED_OBJECT = "esx:getSharedObject",

    -- es_extended resource name
    ES_EXTENDED_NAME = "es_extended",

    -------

    -- qbcore
    QBCORE_SHARED_OBJECT = "QBCore:GetObject",

    -- qb-core resource name
    QB_CORE_NAME = "qb-core",

    -- should the script look it self for framework?
    AutoCheck = true
}

-----------------------------------------------------------------------------------------

-- this will create a new instance of derby on same position but in another world
Config.DerbyArenaNameList = {
    "derby",
    "derby2",
    "derby3",
}

-----------------------------------------------------------------------------------------

-- How the arena will be displayed in game ?
Config.ArenaName = "Derby"

-- Fow how long can arena go ? 5*60 = 5 minutes
Config.MaxArenaTime = 5 * 60

-- How long peopel have to wait in lobby ?
Config.MaxLobbyTime = 30

-- display join message in chat
Config.DisplayJoinMessage = false

-- How many people are required to start arena ?
-- will be best if atleast 2... but hey i am not here
-- to stop you.. change it to 1 if you want. :D
Config.MinimumRequiredPeople = 2

-- if you set this to false, no one will be able to acces the arena
-- so you will have to code the join logic by your self
Config.IsArenaPublic = true

-----------------------------------------------------------------------------------------

-- will enable all effect like shakecam etc
Config.EnableEffects = true

-- Will enable all FX effects
Config.EnableFXEffects = true

-- Will enable shake cam
Config.EnableShakeCam = true

-- Intensity of camera shake
Config.ShakeIntensity = 0.025

-- Identifier for fxEffect
Config.FxEffect = "SMALL_EXPLOSION_SHAKE"

-- Gameplay camera effect name
Config.GameplayCameraEffect = "HeistLocate"

-----------------------------------------------------------------------------------------

-- The middle point of arena
Config.ArenaLocation = vector3(-915.84, -2521.72, 41.67)

-- How far away player can get before respawning and taking one life out ?
Config.ArenaDistance = 30

-- Player cant be below those cords means Z = 30 if player is below Z 30 like 29 it will count as a lost and teleport him back to arena
Config.MinimumZLevel = 35

-- will select one of the random cars here to spawn with
Config.SpawnCarList = {
    "issi5",
}

-- position of the Derby arena
Config.PositionCars = {
    {
        Occupied = false,
        Position = vector3(-904.64, -2501.08, 40.98),
        Heading = 151.76,
    },
    {
        Occupied = false,
        Position = vector3(-921.42, -2503.55, 40.65),
        Heading = 201.11,
    },
    {
        Occupied = false,
        Position = vector3(-897.78, -2515.71, 40.68),
        Heading = 102.38,
    },
    {
        Occupied = false,
        Position = vector3(-925.62, -2538.5, 41.02),
        Heading = 324.13,
    },
    {
        Occupied = false,
        Position = vector3(-932.58, -2524.97, 40.72),
        Heading = 288.91,
    },
    {
        Occupied = false,
        Position = vector3(-910.23, -2536.79, 40.74),
        Heading = 19.24,
    },
}

-----------------------------------------------------------------------------------------
-- these are win prizes after the game end you can add howm any positions you want if the arena has this capacity.
Config.RewardsPositions = {
    [1] = 5000, -- 5000$ for the first position
    [2] = 3000, -- 3000$ for the second position
    [3] = 1000, -- 1000$ for the third position
}

-----------------------------------------------------------------------------------------

Config.AddKey = function(vehicle, plate)
    -- add your event here / export here
end

-- enable revive event
Config.EnableReviveEvent = true

-- Revive event
Config.ReviveEvent = function(cb)
    --[[if Config.Framework.Active == Framework.ESX then
        TriggerServerEvent("esx_ambulancejob:setDeathStatus", false)
        TriggerEvent("esx_ambulancejob:ReviveNoEffects", function()
            if cb then
                cb()
            end
        end)
    end
    if Config.Framework.Active == Framework.QBCORE then
        TriggerEvent("hospital:client:Revive")
    end--]]
    TriggerEvent('AmbulanceJob:revive')
end

-- snippet for esx_ambulancejob
-- this used to be an old snippet when newest es_extended was 1.2 so if you're using this version
-- or it has not been changed how the esx_ambulancejob works then feel free to use it
-- this only does seemless teleport effect with revive its nothing really imporant just for visual looks
--[[
RegisterNetEvent('esx_ambulancejob:ReviveNoEffects')
AddEventHandler('esx_ambulancejob:ReviveNoEffects', function(cb)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)
	SetEntityHealth(playerPed, 200)
	AnimpostfxStop('DeathFailOut')
	if cb then
	    cb()
	end
end)
--]]