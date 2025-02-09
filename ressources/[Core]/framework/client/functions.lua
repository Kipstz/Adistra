Framework                           = {}
Framework.PlayerData                = {}
Framework.PlayerLoaded              = false;
Framework.CurrentRequestId          = 0
Framework.ServerCallbacks           = {}

Framework.Scaleform                 = {}
Framework.Scaleform.Utils           = {}
Framework.Streaming                 = {}

Framework.Game                      = {}
Framework.Game.Utils                = {}

function Framework.IsPlayerLoaded()
	return Framework.PlayerLoaded
end

function Framework.GetPlayerData()
	return Framework.PlayerData
end

function Framework.SetPlayerData(key, val)
	local current = Framework.PlayerData[key]
	Framework.PlayerData[key] = val
	if key ~= 'inventory' and key ~= 'loadout' then
		if type(val) == 'table' or val ~= current then
			TriggerEvent('framework:setPlayerData', key, val, current)
		end
	end
end

function Framework.ShowNotification(msg, title, subject, icon)
	-- BeginTextCommandThefeedPost('STRING')
	-- AddTextComponentSubstringPlayerName(msg)
	-- EndTextCommandThefeedPostTicker(0,1)
	if IsPauseMenuActive() then return end

	if title == nil then title = Config.ServerName2 end
	if subject == nil then subject = "Information" end
	if icon == nil then icon = "message" end

	exports.Notif:Send(msg, nil, nil, true, nil, title, subject, icon)
end

function Framework.ShowAdvancedNotification(title, subject, msg, icon, banner)
	-- if saveToBrief == nil then saveToBrief = true end
	-- AddTextEntry('frameworkAdvancedNotification', msg)
	-- BeginTextCommandThefeedPost('frameworkAdvancedNotification')
	-- if hudColorIndex then ThefeedSetNextPostBackgroundColor(hudColorIndex) end
	-- EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, title, subject)
	-- EndTextCommandThefeedPostTicker(flash or false, saveToBrief)

	if IsPauseMenuActive() then return end

	if title == nil then title = Config.ServerName2 end
	if subject == nil then subject = "Information" end
	if icon == nil then icon = "message" end

	exports.Notif:SendAdvanced(msg, subject, title, banner, nil, nil, true, nil, icon)
end

function Framework.ShowHelpNotification(msg, thisFrame, beep, duration)
	AddTextEntry('frameworkHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('frameworkHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('frameworkHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

function Framework.ShowFloatingHelpNotification(msg, coords)
	AddTextEntry('frameworkFloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('frameworkFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

function Framework.TriggerServerCallback(name, cb, ...)
	Framework.ServerCallbacks[Framework.CurrentRequestId] = cb

	TriggerServerEvent('framework:triggerServerCallback', name, Framework.CurrentRequestId, ...)

	if Framework.CurrentRequestId < 65535 then
		Framework.CurrentRequestId = Framework.CurrentRequestId + 1
	else
		Framework.CurrentRequestId = 0
	end
end


function Framework.Game.SpawnPlayer(spawnIdx, cb)
    CreateThread(function()
        local spawn

        if type(spawnIdx) == 'table' then
            spawn = spawnIdx

            spawn.x = spawn.x + 0.00
            spawn.y = spawn.y + 0.00
            spawn.z = spawn.z + 0.00
            spawn.heading = spawn.heading and (spawn.heading + 0.00) or 0
        else
            spawn = spawnPoints[spawnIdx]
        end

        if not spawn.skipFade then
            DoScreenFadeOut(500)

            while not IsScreenFadedOut() do
                Wait(1)
            end
        end

        if not spawn then
            Citizen.Trace("tried to spawn at an invalid spawn index\n")
            return
        end

		local ped = GetPlayerPed(PlayerId())
		SetPlayerControl(PlayerId(), false, false)
		SetEntityVisible(ped, false, 0)
		SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end

        if spawn.model then
			local waitCount = 0;
            RequestModel(spawn.model)
            while not HasModelLoaded(spawn.model) do
				waitCount = waitCount + 1
				RequestModel(spawn.model)

				if waitCount > 500 then break end
				Wait(100)
			end

			if HasModelLoaded(spawn.model) then
				SetPlayerModel(PlayerId(), spawn.model)
				SetModelAsNoLongerNeeded(spawn.model)
			end
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        ClearPlayerWantedLevel(PlayerId())
		SetPedDefaultComponentVariation(PlayerPedId())

        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do print("col") Wait(1) end

        ShutdownLoadingScreen()
        ShutdownLoadingScreen()

		SetPlayerControl(PlayerId(), true, false)
		while not IsEntityVisible(ped) do
            SetEntityVisible(ped, true, 0)
            Wait(1)
        end
		SetEntityVisible(ped, true, 0)
		SetEntityCollision(ped, true)
        FreezeEntityPosition(ped, false)
		SetEntityInvincible(ped, false)

        TriggerEvent('playerSpawned', spawn)
		if cb then
			cb()
		end
    end)
end

function Framework.Game.GetPedMugshot(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Wait(1)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

function Framework.Game.Teleport(entity, coords, cb)
	local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or vec(coords.x, coords.y, coords.z, coords.heading or 0.0)

	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(vector.xyz)
		while not HasCollisionLoadedAroundEntity(entity) do
			Wait(1)
		end

		SetEntityCoords(entity, vector.xyz, false, false, false, false)
		SetEntityHeading(entity, vector.w)
	end

	if cb then
		cb()
	end
end

function Framework.Game.SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	local loadCount = 0;

	CreateThread(function()
		Framework.Streaming.RequestModel(model)

		local object = CreateObject(model, coords, true, false, true)

		if object ~= nil then
			local id = NetworkGetNetworkIdFromEntity(object)

			SetNetworkIdCanMigrate(id, true)
			SetEntityAsMissionEntity(object, false, false)
			SetModelAsNoLongerNeeded(model)
	
			RequestCollisionAtCoord(coords)
	
			while not HasCollisionLoadedAroundEntity(object) do
				loadCount = loadCount + 0.25

				if loadCount > 20 then
					loadCount = 0
					break
				end

				Wait(1)
			end
		else
			print("[FRAMEWORK] - SpawnObject OBJECT NIL: "..model.." "..object.." "..coords)
		end

		if cb then
			cb(object)
		end
	end)
end

function Framework.Game.SpawnLocalObject(model, coords, cb)
	local coords = vector3(coords.x, coords.y, coords.z)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	local loadCount = 0;

	CreateThread(function()
		Framework.Streaming.RequestModel(model)

		local object = CreateObject(model, coords, false, false, true)

		if object ~= nil then
			SetEntityAsMissionEntity(object, false, false)
			SetModelAsNoLongerNeeded(model)
	
			RequestCollisionAtCoord(coords)
	
			while not HasCollisionLoadedAroundEntity(object) do
				loadCount = loadCount + 0.01

				if loadCount > 20 then
					loadCount = 0

					break
				end

				Wait(1)
			end
		else
			print("[FRAMEWORK] - SpawnLocalObject OBJECT NIL: "..model.." "..object.." "..coords)
		end

		if cb then
			cb(object)
		end
	end)
end

function Framework.Game.DeleteVehicle(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

function Framework.Game.DeleteObject(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

function Framework.Game.SpawnVehicle(vehicle, coords, heading, cb, networked)
	local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	networked = networked == nil and true or networked
	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Wait(1)
		end

		local vehicle = CreateVehicle(model, vector.xyz, heading, networked, false)

		if networked then
			local id = NetworkGetNetworkIdFromEntity(vehicle)
			SetNetworkIdCanMigrate(id, true)
			SetEntityAsMissionEntity(vehicle, true, false)
		end
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		SetVehRadioStation(vehicle, 'OFF')

		RequestCollisionAtCoord(vector.xyz)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			Citizen.Wait(1)
		end

		if cb then
			cb(vehicle)
		end
	end)
end

function Framework.Game.SpawnLocalVehicle(vehicle, coords, heading, cb)
	Framework.Game.SpawnVehicle(vehicle, coords, heading, cb, false)
end

function Framework.Game.IsVehicleEmpty(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

function Framework.Game.GetObjects()
	return GetGamePool('CObject')
end

function Framework.Game.GetPeds(onlyOtherPeds)
	local peds, myPed, pool = {}, PlayerPedId(), GetGamePool('CPed')

	for i=1, #pool do
        if ((onlyOtherPeds and pool[i] ~= myPed) or not onlyOtherPeds) then
			peds[#peds + 1] = pool[i]
        end
    end

	return peds
end

function Framework.Game.GetVehicles()
	return GetGamePool('CVehicle')
end

function Framework.Game.GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				players[#players + 1] = returnPeds and ped or player
			end
		end
	end

	return players
end

function Framework.Game.GetClosestObject(coords, modelFilter)
	return Framework.Game.GetClosestEntity(Framework.Game.GetObjects(), false, coords, modelFilter)
end

function Framework.Game.GetClosestPed(coords, modelFilter)
	return Framework.Game.GetClosestEntity(Framework.Game.GetPeds(true), false, coords, modelFilter)
end

function Framework.Game.SpawnPed(pedType, modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	CreateThread(function()
		Framework.Streaming.RequestModel(model)

		local ped = CreatePed(pedType, model, coords, heading, true, false)
		local id = NetworkGetNetworkIdFromEntity(ped)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(ped, false, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(ped) do
			Wait(50)
		end

		if cb then
			cb(ped)
		end
	end)
end

function Framework.Game.SpawnLocalPed(pedType, modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	CreateThread(function()
		Framework.Streaming.RequestModel(model)
		local ped = CreatePed(pedType, model, coords, heading, false, false)

		SetEntityAsMissionEntity(ped, false, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(ped) do
			Wait(50)
		end

		if cb then
			cb(ped)
		end
	end)
end

function Framework.Game.GetClosestPlayer(coords)
	return Framework.Game.GetClosestEntity(Framework.Game.GetPlayers(true, true), true, coords, nil)
end

function Framework.Game.GetClosestVehicle(coords, modelFilter)
	return Framework.Game.GetClosestEntity(Framework.Game.GetVehicles(), false, coords, modelFilter)
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local plyPed = PlayerPedId()
		coords = GetEntityCoords(plyPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
		end
	end

	return nearbyEntities
end

function Framework.Game.GetPlayersInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(Framework.Game.GetPlayers(true, true), true, coords, maxDistance)
end

function Framework.Game.GetVehiclesInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(Framework.Game.GetVehicles(), false, coords, maxDistance)
end

function Framework.Game.IsSpawnPointClear(coords, maxDistance)
	return #Framework.Game.GetVehiclesInArea(coords, maxDistance) == 0
end

function Framework.Game.GetClosestEntity(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				filteredEntities[#filteredEntities + 1] = entity
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = Vdist(coords, GetEntityCoords(entity))

		if NetworkGetEntityOwner(entity) ~= -1 then
			if closestEntityDistance == -1 or distance < closestEntityDistance then
				closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
			end
		end
	end

	return closestEntity, closestEntityDistance
end

function Framework.Game.GetVehicleInDirection()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartExpensiveSynchronousShapeTestLosProbe(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		local entityCoords = GetEntityCoords(entityHit)
		return entityHit, entityCoords
	end

	return nil
end

function Framework.Game.GetVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local paintType1, whoCaresColor1, nnn = GetVehicleModColor_1(vehicle)
		local paintType2, whoCaresColor2 = GetVehicleModColor_2(vehicle)
		local color3 = {}
		local color4 = {}
		color3[1], color3[2], color3[3] = GetVehicleCustomPrimaryColour(vehicle)
		color4[1], color4[2], color4[3] = GetVehicleCustomSecondaryColour(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local dshcolor = GetVehicleDashboardColour(vehicle)
		local intcolor = GetVehicleInteriorColour(vehicle)
		local drift = GetDriftTyresEnabled(vehicle)
		local extras = {}

		for id=0, 12 do
			if DoesExtraExist(vehicle, id) then
				local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
				extras[tostring(id)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = Framework.Math.Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = Framework.Math.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = Framework.Math.Round(GetVehicleEngineHealth(vehicle), 1),

			fuelLevel         = Framework.Math.Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = Framework.Math.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,
			color3            = color3,
			color4            = color4,
			paintType		  = {paintType1, paintType2},
			ColorType 		  = {whoCaresColor1, whoCaresColor2},	
			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,
			dshcolor 		  = dshcolor,
			intcolor 		  = intcolor,
			drift			  = drift,
			
			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),
			modWheelVariat	  = GetVehicleModVariation(vehicle,23),
			modTyresBurst     = GetVehicleTyresCanBurst(vehicle),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleLivery(vehicle),
			modLivery2         = GetVehicleMod(vehicle, 48),
		}
	else
		return
	end
end

function Framework.Game.SetVehicleProperties(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.color3 ~= nil then 
			ClearVehicleCustomPrimaryColour(vehicle)
			SetVehicleCustomPrimaryColour(vehicle, props.color3[1], props.color3[2], props.color3[3])
		end
		if props.color4 ~= nil then
			ClearVehicleCustomSecondaryColour(vehicle)
			SetVehicleCustomSecondaryColour(vehicle, props.color4[1], props.color4[2], props.color4[3])
		end
		if props.paintType ~= nil then
			local coraplicarp = 0
			local coraplicars = 0
			if props.ColorType then
				coraplicarp = props.ColorType[1]
				coraplicars = props.ColorType[2]
			end
			SetVehicleModColor_1(vehicle, props.paintType[1], coraplicarp, 0)
			SetVehicleModColor_2(vehicle, props.paintType[2], coraplicars)
		end
		if props.dshcolor ~= nil then
			SetVehicleDashboardColour(vehicle, props.dshcolor)
		end
		if props.intcolor ~= nil then
			SetVehicleInteriorColour(vehicle, props.intcolor)
		end
		if props.drift ~= nil then
			SetDriftTyresEnabled(vehicle,props.drift)
		end

		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for id,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id), 0)
				else
					SetVehicleExtra(vehicle, tonumber(id), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modTyresBurst ~= nil then
			SetVehicleTyresCanBurst(vehicle,props.modTyresBurst)
		end
		if props.modFrontWheels ~= nil then
			local aplicar = false
			if props.modWheelVariat then
				aplicar = props.modWheelVariat
			end
			SetVehicleMod(vehicle, 23, props.modFrontWheels, aplicar)
		end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleLivery(vehicle, props.modLivery)
		end
		if props.modLivery2 then
			SetVehicleMod(vehicle, 48, props.modLivery2, false)
		end
	end
end

function Framework.Game.Utils.DrawText3D(coords, text, size, font)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

	local camCoords = GetFinalRenderedCamCoord()
	local distance = #(vector - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	BeginTextCommandDisplayText('STRING')
	SetTextCentre(true)
	AddTextComponentSubstringPlayerName(text)
	SetDrawOrigin(vector.xyz, 0)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

RegisterNetEvent('framework:serverCallback')
AddEventHandler('framework:serverCallback', function(requestId, ...)
	Framework.ServerCallbacks[requestId](...)
	Framework.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('framework:showNotification')
AddEventHandler('framework:showNotification', function(msg)
	Framework.ShowNotification(msg)
end)

RegisterNetEvent('framework:showAdvancedNotification')
AddEventHandler('framework:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	Framework.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

RegisterNetEvent('framework:showHelpNotification')
AddEventHandler('framework:showHelpNotification', function(msg, thisFrame, beep, duration)
	Framework.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

local WeaponsBoutique = {
	'WEAPON_KATANA', 
	'WEAPON_CARBINERIFLE2', 'WEAPON_CARBINERIFLE3', 'WEAPON_CARBINERIFLE4', 'WEAPON_CARBINERIFLE5', 'WEAPON_CARBINERIFLE6', 'WEAPON_CARBINERIFLE7', 
    'WEAPON_ANIMEM4', 
	'WEAPON_SCORPION', 
	'WEAPON_RGXOPERATOR',
	'WEAPON_SPECIALCARBINE2_MK2',
	'WEAPON_KNIFE2',
	'WEAPON_SPIKEDCLUB',
	'WEAPON_KATANA2',
	'WEAPON_JOSM4A4CH',
	'WEAPON_SPECIALCARBINE2', 'WEAPON_SPECIALCARBINE3',
	'WEAPON_MARKSMANRIFLE2',

	-- WEAPONS PACK --
	'WEAPON_A15RC',
	'WEAPON_NEVA',
	'WEAPON_IAR',
	'WEAPON_M133',
	'WEAPON_JRBAK',
	'WEAPON_FAMASU1',
	'WEAPON_GRAU',
	'WEAPON_AK47S',
	'WEAPON_SR47',
	'WEAPON_AK4K',
	'WEAPON_AKMKH',
	'WEAPON_BULLDOG',
	'WEAPON_CASR',
	'WEAPON_DRH',
	'WEAPON_FMR',
	'WEAPON_FN42',
	'WEAPON_GALILAR',
	'WEAPON_M16A3',
	'WEAPON_SLR15',
	'WEAPON_ARC15',
	'WEAPON_ARS',
	'WEAPON_HOWA_2',
	'WEAPON_MZA',
	'WEAPON_SAFAK',
	'WEAPON_SAR',
	'WEAPON_SFAK',
	'WEAPON_ARMA1',
	'WEAPON_G36',
	'WEAPON_LR300',
	'WEAPON_M416P',
	'WEAPON_NANITE',
	'WEAPON_SF2',
	'WEAPON_SFRIFLE',
	'WEAPON_CFS',
	'WEAPON_AK47',
	'WEAPON_AUG',
	'WEAPON_SUNDA',
	'WEAPON_G3_2',
	'WEAPON_GROZA',
	'WEAPON_ACR',
	'WEAPON_ACWR',
	'WEAPON_ANARCHY',
	'WEAPON_FAR',
	'WEAPON_GK47',
	'WEAPON_TAR21',
	'WEAPON_AKPU',
	'WEAPON_AN94_2',
	'WEAPON_ART64',
	'WEAPON_GYS',
	'WEAPON_SM237',
	'WEAPON_SS2_2',
	'WEAPON_SCARSC',
	'WEAPON_VA030',
	'WEAPON_AR121',
	'WEAPON_LGWII',
	'WEAPON_AR727',
	'WEAPON_ANR15',
	'WEAPON_DKS501',
	'WEAPON_SCIFW',
	'WEAPON_SSR56',
	'WEAPON_AKBG',
	'WEAPON_ANM4',
	'WEAPON_GVANDAL',
	'WEAPON_L85',
	'WEAPON_LIMPID',
	'WEAPON_TRUVELO',
	'WEAPON_SB4S',
	'WEAPON_H2SMG',
	'WEAPON_HFSMG',
	'WEAPON_MS32',
	'WEAPON_SARB',
	'WEAPON_UE4',
	'WEAPON_UZI',
	'WEAPON_IDW',
	'WEAPON_HEAVYSMG',
	'WEAPON_SMG9',
	'WEAPON_R99',
	'WEAPON_SB181',
	'WEAPON_UMP45',
	'WEAPON_SMG1311',
	'WEAPON_AUTOSMG',
	'WEAPON_MX4',
	'WEAPON_PASMG',
	'WEAPON_FN502',
	'WEAPON_HFAP',
	'WEAPON_KNR',
	'WEAPON_CZ75',
	'WEAPON_PL14',
	'WEAPON_AWP',
	'WEAPON_DITDG',
	'WEAPON_M82',
	'WEAPON_M90S',
	'WEAPON_DCS',
	'WEAPON_OWSHOTGUN',
	'WEAPON_BENELLIM4',
	'WEAPON_BOOK',
	'WEAPON_BRICK',
	'WEAPON_ENERGYKNIFE',
	'WEAPON_HIGHBOOT',
	'WEAPON_KARAMBIT',
	
	'WEAPON_PISTOLWHITE',
	'WEAPON_PISTOLBLACK',
	'WEAPON_PISTOLPOKA',
	'WEAPON_PISTOLCALIBRE50',
	'WEAPON_KERTUS',
	'WEAPON_AWPMK02',
	'WEAPON_AKMK01',
	
	'WEAPON_VANDALEX',
	'WEAPON_MENACE',
}

Framework.WeaponisBoutique = function(weaponName)
	for k,v in pairs(WeaponsBoutique) do
		if v == weaponName then
			return true
		end
	end

	return false
end

Framework.PaymentMenu = RageUI.CreateMenu("Paiement", "Moyen de Paiement", 8, 200)

local open = false

Framework.PaymentMenu.Closed = function()
	open = false
end

function Framework.PaymentMethod(price, cb)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Framework.PaymentMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Framework.PaymentMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Framework.PaymentMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Paiement en cash (~g~"..price.."$~s~)", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
							RageUI.CloseAll()
							cb(price, 'money')
                        end
                    end)

					RageUI.ButtonWithStyle("Paiement en Carte-Banquaire (~g~"..price.."$~s~)", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
							RageUI.CloseAll()
							cb(price, 'bank')
                        end
                    end)

					RageUI.Line()

					RageUI.ButtonWithStyle("Annuler", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
							RageUI.CloseAll()
							cb(nil)
                        end
                    end)

				end)
			end
		end)
	end
end

-- Credits to txAdmin for the list.
local mismatchedTypes = {
    [`airtug`] = "automobile",       -- trailer
    [`avisa`] = "submarine",         -- boat
    [`blimp`] = "heli",              -- plane
    [`blimp2`] = "heli",             -- plane
    [`blimp3`] = "heli",             -- plane
    [`caddy`] = "automobile",        -- trailer
    [`caddy2`] = "automobile",       -- trailer
    [`caddy3`] = "automobile",       -- trailer
    [`chimera`] = "automobile",      -- bike
    [`docktug`] = "automobile",      -- trailer
    [`forklift`] = "automobile",     -- trailer
    [`kosatka`] = "submarine",       -- boat
    [`mower`] = "automobile",        -- trailer
    [`policepoliceb`] = "bike",            -- automobile
    [`ripley`] = "automobile",       -- trailer
    [`rrocket`] = "automobile",      -- bike
    [`sadler`] = "automobile",       -- trailer
    [`sadler2`] = "automobile",      -- trailer
    [`scrap`] = "automobile",        -- trailer
    [`slamtruck`] = "automobile",    -- trailer
    [`Stryder`] = "automobile",      -- bike
    [`submersible`] = "submarine",   -- boat
    [`submersible2`] = "submarine",  -- boat
    [`thruster`] = "heli",           -- automobile
    [`towtruck`] = "automobile",     -- trailer
    [`towtruck2`] = "automobile",    -- trailer
    [`tractor`] = "automobile",      -- trailer
    [`tractor2`] = "automobile",     -- trailer
    [`tractor3`] = "automobile",     -- trailer
    [`trailersmall2`] = "trailer",   -- automobile
    [`utillitruck`] = "automobile",  -- trailer
    [`utillitruck2`] = "automobile", -- trailer
    [`utillitruck3`] = "automobile", -- trailer
}

---@param model number|string
---@return string
function Framework.GetVehicleType(model)
    model = type(model) == 'string' and joaat(model) or model
    if not IsModelInCdimage(model) then return end
    if mismatchedTypes[model] then
        return mismatchedTypes[model]
    end

    local vehicleType = GetVehicleClassFromName(model)
    local types = {
        [8] = "bike",
        [11] = "trailer",
        [13] = "bike",
        [14] = "boat",
        [15] = "heli",
        [16] = "plane",
        [21] = "train",
    }

    return types[vehicleType] or "automobile"
end