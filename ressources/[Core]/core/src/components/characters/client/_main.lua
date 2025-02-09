
Characters = {}

Characters.instanceId = 1;

RegisterNetEvent('characters:createCharacter')
AddEventHandler('characters:createCharacter', function(id)
    Characters:SceneStart(id)
end)

RegisterNetEvent('characters:selectCharacter')
AddEventHandler('characters:selectCharacter', function(characters)
    Characters:OpenSelectorMenu(characters)
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'skin' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent('characters:init')
AddEventHandler('characters:init', function(id)
    Wait(2500)

    ExecuteCommand('hud')
    DisplayRadar(false)

    VisualManager:loadingShow("Chargement de l'éditeur de personnage", 4)

    TriggerEvent('characters:playAnimation', id)

    SetTimeout(1500, function()
        VisualManager:loadingHide()
    end)
end)

RegisterNetEvent('characters:playAnimation')
AddEventHandler('characters:playAnimation', function(id)
    RenderScriptCams(0,0,0,0,0)
    local animation = true

    SwitchOutPlayer(PlayerPedId(), 0, 1)

    Wait(1500)

    DoScreenFadeIn(3000)
    
    VisualManager:drawTextWithSmooth(function()
        return (animation)
    end, 1920/2, (1080/2)+300, "Bienvenue sur ".._Config.serverName, {252, 255, 255}, function()
        SwitchInPlayer(PlayerPedId())

        Wait(1500)

        DisplayRadar(true)

        VisualManager:loadingHide()

        TriggerEvent('instance:registerType', 'skin')
        TriggerEvent('instance:create', 'skin', {instanceId = math.random(1, 500)})

        Characters:SceneStart(id)
    end)

    Wait(1500)
    VisualManager:loadingShow("Chargement du personnage", 5)
    Wait(1000)
    VisualManager:loadingShow("Synchronisation heure et météo", 5)
    Wait(1500)
    VisualManager:loadingShow("Bienvenue sur ".._Config.serverName, 4)
    Wait(1000)
    animation = false
end)

function Characters:CreateCam()
end

function Characters:DestroyCam()
    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, true, false)
    SetCamActive(camSpawn, false)
end

SceneStart = false
function Characters:SceneStart(id)
    SceneStart = true
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)

    local coords, heading = Config["Characters"].ScenesCoords.scene_start.coords, Config["Characters"].ScenesCoords.scene_start.heading

    while Vdist(myCoords, coords) > 1.5 do
        myCoords = GetEntityCoords(plyPed)
        SetEntityCoords(plyPed, coords)
        SetEntityHeading(plyPed, heading)
        Wait(1000)
    end

    FreezeEntityPosition(plyPed, true)
    SetEntityInvincible(plyPed, true)
    DisplayRadar(false)
    Characters:DestroyCam()
    TriggerEvent('skinchanger:change', 'sex', 0)
    Wait(1500)
    for k,v in pairs(Config["Characters"]['vetements'].m) do
        TriggerEvent('skinchanger:change', k, v)
    end
    Characters:OpenCreatorMenu(id, true)
    SceneStart = false
end

SceneFinal = false
function Characters:SceneFinal()
    SceneFinal = true
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)
    local coords, heading = Config["Characters"].ScenesCoords.scene_end.coords, Config["Characters"].ScenesCoords.scene_end.heading
    local coords2, coords3 = Config["Characters"].ScenesCoords.scene_end.coords2, Config["Characters"].ScenesCoords.scene_end.coords3
    local coords4, coords5 = Config["Characters"].ScenesCoords.scene_end.coords4, Config["Characters"].ScenesCoords.scene_end.coords5
    local coords6, coords_final = Config["Characters"].ScenesCoords.scene_end.coords6, Config["Characters"].ScenesCoords.scene_end.coords_final

    FreezeEntityPosition(plyPed, false)
    SetEntityInvincible(plyPed, false)

    while Vdist(myCoords, coords) > 1.5 do myCoords = GetEntityCoords(plyPed) SetEntityCoords(plyPed, coords) SetEntityHeading(plyPed, heading) Wait(1000) end
    DoScreenFadeIn(1500)
    TaskGoStraightToCoord(plyPed, coords2, 1.0, 1000*60, -90.0, 0.0)

    while Vdist(myCoords, coords2) > 0.3 do myCoords = GetEntityCoords(plyPed) Wait(1) end
    TaskGoToCoordAnyMeans(plyPed, coords3, 1.0)

    while Vdist(myCoords, coords3) > 0.3 do myCoords = GetEntityCoords(plyPed) Wait(1) end
    TaskGoToCoordAnyMeans(plyPed, coords4, 1.0)

    while Vdist(myCoords, coords4) > 0.3 do myCoords = GetEntityCoords(plyPed) Wait(1) end
    TaskGoToCoordAnyMeans(plyPed, coords5, 1.0)

    while Vdist(myCoords, coords5) > 0.3 do myCoords = GetEntityCoords(plyPed) Wait(1) end
    TaskGoToCoordAnyMeans(plyPed, coords6, 1.0)

    while Vdist(myCoords, coords6) > 0.3 do myCoords = GetEntityCoords(plyPed) Wait(1) end
    TaskGoStraightToCoord(plyPed, coords_final, 1.0, 1000*60, 0.0, 0.0)

    DisplayRadar(true)
    ExecuteCommand('hud')
    TriggerEvent('instance:leave')
    SceneFinal = false
end