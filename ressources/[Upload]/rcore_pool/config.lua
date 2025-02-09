Config = {
    Framework = 0, --[ 1 = ESX / 2 = QBCore / 3 = Other ] Choose your framework
	SocietySystem = 0, --[ 1 = esx_addonaccount / 2 = qb-bossmenu / 3 = qb-management ]

	FrameworkTriggers = {
		notify = '', -- [ ESX = 'esx:showNotification' / QBCore = 'QBCore:Notify' ] Set the notification event, if left blank, default will be used
		object = '', --[ ESX = 'esx:getSharedObject' / QBCore = 'QBCore:GetObject' ] Set the shared object event, if left blank, default will be used (deprecated for QBCore)
		resourceName = '', -- [ ESX = 'es_extended' / QBCore = 'qb-core' ] Set the resource name, if left blank, automatic detection will be performed
	},
    
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
    },

    -- qtarget
	UseQTarget = false,

	-- BT-Target
	UseBTTarget = false,

	-- QB-Target
	UseQBTarget = false,

	-- OX-Target
	UseOXTarget = false,

    --[[
        Uses esx/qbcore notifications. Set to false for native GTA notifications
    ]]
    UseFrameworkNotification = true,

    --[[
        -- To use custom menu, implement following client handlers
        AddEventHandler('rcore_pool:openMenu', function()
            -- open menu with your system
        end)

        AddEventHandler('rcore_pool:closeMenu', function()
            -- close menu, player has walked far from table
        end)


        -- After selecting game type, trigger one of the following setupTable events
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_9_BALL')
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_STRAIGHT_POOL')
    ]]
    CustomMenu = false,

    --[[
        When you want your players to pay to play pool, set this to true and set BallSetupCost
    ]]
    PayForSettingBalls = false,
    BallSetupCost = 100, -- for example: 1 or 200 - MUST be number

    SocietyPrefix = 'society_',
    PayToSociety = {
        -- {poolTableCoords = vector3(-572.91, 288.42, 79.17), society = 'jobname'}
    },

    DrawShotPreviewLine = true,

    --[[
        You can integrate pool cue into your system with

        SERVERSIDE HANDLERS
            - rcore_pool:onReturnCue - called when player takes cue
            - rcore_pool:onTakeCue   - called when player returns cue
            - rcore_pool:requestPoolCue   - forces player to take cue in hand
            - rcore_pool:requestRemoveCue - removes cue from player's hand

        This prevents players from taking cue from cue rack if `false`
    ]]
    AllowTakePoolCueFromStand = true,

    --[[
        This option is for servers whose anticheats prevents
        this script from setting players invisible.

        When player's ped is blocking camera when aiming,
        set this to true
    ]]
    DoNotRotateAroundTableWhenAiming = false,
    
    AllowedPoolPlaces = nil, -- {vector3(-574.52, 288.8, 79.17)},

    --[[
        When set to true, you MUST send the following server->client event
        when changing player's bucket

        TriggerClientEvent('rcore_pool:setBucket', serverId, bucketId)
    ]]
    UseBuckets = false,

    Debug = false,

    MenuColor = {147, 184, 168},
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = { 
        BACK = "Retour",
        HIT = "Tirer",
        BALL_IN_HAND = "Prendre la balle",
        BALL_IN_HAND_BACK = "Déposer",
        AIM_LEFT = "Viser à gauche",
        AIM_RIGHT = "Viser à droite",
        AIM_SLOWER = "Viser plus doucement",
    
        POOL = 'Billard',
        POOL_GAME = 'Jeu de billard',
        POOL_SUBMENU = 'Sélectionner la configuration des billes',
        TYPE_9_BALL = '9-billes',
        TYPE_STRAIGHT = 'Billard à 8 ou billard libre',
        POOL_SETUP = 'Configuration : ',
    
        HINT_SETUP = 'Configurer la table',
        HINT_TAKE_CUE = 'Prendre la queue de billard',
        HINT_RETURN_CUE = 'Rendre la queue de billard',
        HINT_HINT_TAKE_CUE = 'Pour jouer au billard, prenez la queue de billard sur le support',
        HINT_PLAY = 'Jouer',
    
        NOT_ENOUGH_MONEY = 'Vous n\'avez pas assez d\'argent ($%s) pour configurer cette table.',
    
        BALL_IN_HAND_LEFT = 'Gauche',
        BALL_IN_HAND_RIGHT = 'Droite',
        BALL_IN_HAND_UP = 'Haut',
        BALL_IN_HAND_DOWN = 'Bas',
        BALL_POCKETED = 'La bille %s a été empochée',
        BALL_IN_HAND_NOTIFY = 'Le joueur a pris la bille blanche en main',
        BALL_LABELS = {
            [-1] = 'Queue',
            [1] = '~y~Pleine 1~s~',
            [2] = '~b~Pleine 2~s~',
            [3] = '~r~Pleine 3~s~',
            [4] = '~p~Pleine 4~s~',
            [5] = '~o~Pleine 5~s~',
            [6] = '~g~Pleine 6~s~',
            [7] = '~r~Pleine 7~s~',
            [8] = 'Noire pleine 8',
            [9] = '~y~Rayée 9~s~',
            [10] = '~b~Rayée 10~s~',
            [11] = '~r~Rayée 11~s~',
            [12] = '~p~Rayée 12~s~',
            [13] = '~o~Rayée 13~s~',
            [14] = '~g~Rayée 14~s~',
            [15] = '~r~Rayée 15~s~',
        }
    },
}

if Config.UseFrameworkNotification then
    for idx, text in pairs(Config.Text.BALL_LABELS) do
        Config.Text.BALL_LABELS[idx] = text:gsub('~.~', '')
    end
end

if Config.UseQTarget then
	Config.TargetResourceName = 'qtarget'
end
if Config.UseBTTarget then
	Config.TargetResourceName = 'bt-target'
end
if Config.UseQBTarget then
	Config.TargetResourceName = 'qb-target'
end
if Config.UseOXTarget then
	Config.TargetResourceName = 'ox_target'
end