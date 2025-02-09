
function Boutique:getCoins()
    return Boutique.myCoins or 0;
end

function Boutique:setLastCoords(coords)
    Boutique.myLastCoords = coords
end

function Boutique:createCam(fov)
    DestroyAllCams(true)
    camStart = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config['boutique'].CamCoords, -10.0, 0.0, -150.0, fov)
    SetCamActive(camStart, true)
    RenderScriptCams(true, false, 0, true, false)
end

function Boutique:setVehicleProperties(props, vehicle)
    Boutique.vehicleSpawnProps = props
    Boutique.vehicleSpawn = vehicle
end

Boutique.weaponSpawn = {}
Boutique.itemLoaded = false;
Boutique.lastItem = nil;
Boutique.inShow = false;

function Boutique:spawnItem(model, type, price)
    if Boutique.lastItem ~= model and IsModelValid(model) then
        local plyPed = PlayerPedId()
        Boutique.itemLoaded = false;

        SetEntityVisible(plyPed, false)
        SetEntityCoords(plyPed, Config['boutique'].ItemSpawn)
        
        Boutique.lastItem = model;

        if type == 'cars' then
            RequestModel(GetHashKey(model))

            while not HasModelLoaded(GetHashKey(model)) do
                Wait(10)

                Boutique.drawMsg("Chargement en cours...")
            end

            Boutique:createCam(40.0)

            if Framework.Game.IsSpawnPointClear(Config['boutique'].ItemSpawn, 5.0) then
                Framework.Game.SpawnLocalVehicle(model, Config['boutique'].ItemSpawn, 0.0, function(vehicle) 
                    Boutique.itemLoaded = true;

                    local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)
                    Boutique:setVehicleProperties(vehicleProps, vehicle)

                    FreezeEntityPosition(vehicle, true)
                    SetVehicleDoorsLocked(vehicle, 2)
                    SetEntityInvincible(vehicle, true)
                    SetVehicleFixed(vehicle)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetVehicleEngineOn(vehicle, true, true, true)
                    SetVehicleLights(vehicle, 2)

                    while Boutique.inShow do
                        Wait(1)
        
                        SetEntityHeading(vehicle, (GetEntityHeading(vehicle) + 0.20))
                    end
                end)
            else
                for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['boutique'].ItemSpawn, 5.0)) do
                    Framework.Game.DeleteVehicle(v)
                end

                Framework.Game.SpawnLocalVehicle(model, Config['boutique'].ItemSpawn, 0.0, function(vehicle)
                    Boutique.itemLoaded = true;

                    local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)
                    Boutique:setVehicleProperties(vehicleProps, vehicle)

                    FreezeEntityPosition(vehicle, true)
                    SetVehicleDoorsLocked(vehicle, 2)
                    SetEntityInvincible(vehicle, true)
                    SetVehicleFixed(vehicle)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetVehicleEngineOn(vehicle, true, true, true)
                    SetVehicleLights(vehicle, 2)

                    while Boutique.inShow do
                        Wait(1)
        
                        SetEntityHeading(vehicle, (GetEntityHeading(vehicle) + 0.20))
                    end
                end)
            end
        elseif type == 'armes_assaults' or 'armes_pistols' or 'armes_snipers' or 'armes_pompes' or 'armes_meles' then
            Boutique:createCam(13.0)

            for k,v in pairs(Boutique.weaponSpawn) do
                DeleteObject(v)
            end

            Framework.Game.SpawnLocalObject(model, Config['boutique'].ItemSpawn, function(object)
                Boutique.itemLoaded = true;
                table.insert(Boutique.weaponSpawn, object)

                while Boutique.inShow do
                    Wait(1)
                    
                    SetEntityHeading(object, (GetEntityHeading(object) + 0.50))
                end
            end)
        end
    end
end

function Boutique:destroyShow()
    Boutique.inShow = false;
    Boutique.lastItem = nil;

    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, true, false)
    SetEntityVisible(PlayerPedId(), true)

    for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['boutique'].ItemSpawn, 5.0)) do Framework.Game.DeleteVehicle(v) end
    for k,v in pairs(Boutique.weaponSpawn) do DeleteObject(v) end
end

function Boutique:destroyShow2()
    Boutique.inShow = false;
    Boutique.lastItem = nil;

    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, true, false)
    SetEntityCoords(PlayerPedId(), Boutique.myLastCoords.x, Boutique.myLastCoords.y, Boutique.myLastCoords.z-1.0)
    SetEntityVisible(PlayerPedId(), true)
    Boutique.myLastCoords = nil;

    for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['boutique'].ItemSpawn, 5.0)) do Framework.Game.DeleteVehicle(v) end
    for k,v in pairs(Boutique.weaponSpawn) do DeleteObject(v) end
end

function Boutique:drawMsg(msg)
	SetTextFont(4)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayText(0.450, 0.850)
end

Boutique.inTimeout = false;

function Boutique:setTimeout(time)
    Boutique.inTimeout = true;

    CreateThread(function()
        while true do
            Wait(1000)
            
            if time > 0 then
                time = time - 1000
            else
                Boutique.inTimeout = false;
            end
        end
    end)
end

function Boutique:random(percent)
    assert(percent >= 0 and percent <= 100)
    return percent >= math.random(1, 100)
end

function Boutique:caisse(caisse)
    for k,v in pairs(caisse.gains) do
        local gain = Boutique:random(v.chance)

        if gain then
            if v.type ~= 'vehicle' then
                exports["ac"]:ExecuteServerEvent('boutique:buyCaisse', caisse.price, v)
            elseif v.type == 'vehicle' then
                Framework.Game.SpawnLocalVehicle(v.name, vector3(0.0, 0.0, 0.0), 0.0, function(vehicle)
                    local newPlate = Concess:GeneratePlate()
                    SetVehicleNumberPlateText(vehicle, newPlate)

                    local vehicleProps = Framework.Game.GetVehicleProperties(vehicle) 
                    exports["ac"]:ExecuteServerEvent('boutique:buyCaisse', caisse.price, v, vehicleProps)

                    Framework.Game.DeleteVehicle(vehicle)
                end)
            end

            return
        end
    end

    Boutique:giveConsolation(caisse.price)
end

function Boutique:giveConsolation(price)
    exports["ac"]:ExecuteServerEvent('boutique:giveConsolation', price)
end