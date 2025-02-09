CreateThread(function()
	while true do
		Wait(1)

		if NetworkIsPlayerActive(PlayerId()) then
			DoScreenFadeOut(0)
			Wait(500)
			TriggerServerEvent('framework:onPlayerJoined')

			break
		end
	end
end)

RegisterNetEvent('framework:playerLoaded')
AddEventHandler('framework:playerLoaded', function(xPlayer, isNew, skin)
	Framework.PlayerLoaded = true;
	Framework.PlayerData = xPlayer

	local coords = vector3(684.2, 1018.9, 364.6)
	Framework.Game.SpawnPlayer({
		x = coords.x,
		y = coords.y,
		z = coords.z,
		heading = 90.0,
		model = GetHashKey("mp_m_freemode_01"),
		skipFade = false
	}, function()
		DoScreenFadeIn(5000)

		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()

		FreezeEntityPosition(PlayerPedId(), true)
		SetEntityVisible(PlayerPedId(), false)
	end)

	while PlayerPedId() == nil do Wait(20) end
end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
	local canSetPos = false
	Framework.PlayerLoaded = true;

	if Framework.PlayerData.characterId == nil then canSetPos = true end

	Framework.PlayerData.characterId = xPlayer.characterId
	Framework.PlayerData.identity    = xPlayer.identity
	Framework.PlayerData.skin        = xPlayer.skin
	Framework.PlayerData.accounts    = xPlayer.accounts
	Framework.PlayerData.jobs        = xPlayer.jobs
	Framework.PlayerData.inventory   = xPlayer.inventory
	Framework.PlayerData.loadout     = xPlayer.loadout
	Framework.PlayerData.position    = xPlayer.position
	Framework.PlayerData.maxWeight   = xPlayer.maxWeight

	if canSetPos then
		SetEntityVisible(PlayerPedId(), true)
		FreezeEntityPosition(PlayerPedId(), false)
		SetEntityCoords(PlayerPedId(), xPlayer.position.x, xPlayer.position.y, xPlayer.position.z)
		TriggerEvent('framework:restoreLoadout')
		Wait(2500)
		StartServerSyncLoops()
	end
end)

RegisterNetEvent('framework:onPlayerLogout')
AddEventHandler('framework:onPlayerLogout', function()
	Framework.PlayerLoaded = false;
end)

RegisterNetEvent('framework:setCoins')
AddEventHandler('framework:setCoins', function(coins)
	Framework.PlayerData.coins = coins

	Framework.SetPlayerData('coins', Framework.PlayerData.coins)
end)

RegisterNetEvent('framework:registerSuggestions')
AddEventHandler('framework:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('framework:spawnVehicle')
AddEventHandler('framework:spawnVehicle', function(vehicle)
	Framework.TriggerServerCallback("framework:isUserAdmin", function(admin)
		if admin then
			local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))

			if IsModelInCdimage(model) then
				local playerCoords, playerHeading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())

				Framework.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
					TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				end)
			else
				Framework.ShowNotification('Invalid vehicle model.')
			end
		end
	end)
end)

RegisterNetEvent('framework:deleteVehicle')
AddEventHandler('framework:deleteVehicle', function(radius)
	local plyPed = PlayerPedId()
	
	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = Framework.Game.GetVehiclesInArea(GetEntityCoords(plyPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				Framework.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = Framework.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(plyPed, true) then
			vehicle = GetVehiclePedIsIn(plyPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			Framework.Game.DeleteVehicle(vehicle)
		end
	end
end)

local pickups = {}

RegisterNetEvent('framework:createPickup')
AddEventHandler('framework:createPickup', function(pickupId, label, coords, type, name, components, tintIndex)
	--[[local function setObjectProperties(object)
		SetEntityAsMissionEntity(object, true, false)
		PlaceObjectOnGroundProperly(object)
		FreezeEntityPosition(object, true)
		SetEntityCollision(object, false, true)

		pickups[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = vector3(coords.x, coords.y, coords.z)
		}
	end

	if type == 'item_weapon' then
		local weaponHash = GetHashKey(name)
		Framework.Streaming.RequestWeaponAsset(weaponHash)
		local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
		SetWeaponObjectTintIndex(pickupObject, tintIndex)

		for k,v in ipairs(components) do
			local component = Framework.GetWeaponComponent(name, v)
			GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
		end

		setObjectProperties(pickupObject)
	else
		Framework.Game.SpawnLocalObject('prop_money_bag_01', coords, setObjectProperties)
	end]]
end)

RegisterNetEvent('framework:createMissingPickups')
AddEventHandler('framework:createMissingPickups', function(missingPickups)
	for pickupId, pickup in pairs(missingPickups) do
		TriggerEvent('framework:createPickup', pickupId, pickup.label, pickup.coords, pickup.type, pickup.name, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('framework:removePickup')
AddEventHandler('framework:removePickup', function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		Framework.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

RegisterNetEvent('framework:getvehicletype')
AddEventHandler('framework:getvehicletype', function(model)
	TriggerServerEvent('framework:vehicletype', model, Framework.GetVehicleType(model))
end)

CreateThread(function()
	while true do
		local Sleep = 1500
		local playerCoords = GetEntityCoords(PlayerPedId())
		local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer(playerCoords)

		for pickupId,pickup in pairs(pickups) do
			local distance = #(playerCoords - pickup.coords)

			if distance < 5 then
				Sleep = 1
				local label = pickup.label

				if distance < 1 then
					if IsControlJustReleased(0, 38) then
						if IsPedOnFoot(PlayerPedId()) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
							pickup.inRange = true

							local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
							Framework.Streaming.RequestAnimDict(dict)
							TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
							Wait(1000)

							exports["ac"]:ExecuteServerEvent('framework:onPickup', pickupId)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						end
					end

					label = ('%s~n~%s'):format(label, "Appuyez sur ~r~E~s~ pour ramasser")
				end

				Framework.Game.Utils.DrawText3D({
					x = pickup.coords.x,
					y = pickup.coords.y,
					z = pickup.coords.z + 0.25
				}, label, 1.2, 1)
			elseif pickup.inRange then
				pickup.inRange = false
			end
		end
		Wait(Sleep)
	end
end)

RegisterNetEvent("framework:tpm")
AddEventHandler("framework:tpm", function()
	freecamAutorization = true
	local PlayerPedId = PlayerPedId
	local GetEntityCoords = GetEntityCoords
	local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
	
	Framework.TriggerServerCallback("framework:isUserAdmin", function(admin)
		if admin then
			local blipMarker = GetFirstBlipInfoId(8)
			if not DoesBlipExist(blipMarker) then
				Framework.ShowNotification("Aucun Marker.")
				return 'marker'
			end
			DoScreenFadeOut(650)
			while not IsScreenFadedOut() do Wait(1) end
		
			local ped, coords = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local oldCoords = GetEntityCoords(ped)
		
			local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
			local found = false
			if vehicle > 0 then FreezeEntityPosition(vehicle, true) else FreezeEntityPosition(ped, true) end
		
			for i = Z_START, 0, -25.0 do
				local z = i
				if (i % 2) ~= 0 then z = Z_START - i end
		
				NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
				local curTime = GetGameTimer()
				while IsNetworkLoadingScene() do if GetGameTimer() - curTime > 1000 then break end Wait(1) end
				
				NewLoadSceneStop()
				SetPedCoordsKeepVehicle(ped, x, y, z)
		
				while not HasCollisionLoadedAroundEntity(ped) do
					RequestCollisionAtCoord(x, y, z)
					if GetGameTimer() - curTime > 1000 then break end
					Wait(1)
				end
		
				found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
				if found then
					Wait(1)
					SetPedCoordsKeepVehicle(ped, x, y, groundZ)
					break
				end
				Wait(1)
			end
	
			DoScreenFadeIn(650)
			if vehicle > 0 then FreezeEntityPosition(vehicle, false) else FreezeEntityPosition(ped, false) end
		
			if not found then
				SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
				Framework.ShowNotification('Téléporté avec Succès')
			end
			
			SetPedCoordsKeepVehicle(ped, x, y, groundZ)
			Framework.ShowNotification('Téléporté avec Succès')
		end
	end)
	Citizen.Wait(5000)
	freecamAutorization = false
end)