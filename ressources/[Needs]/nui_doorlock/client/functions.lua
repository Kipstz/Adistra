
nearbyDoors, closestDoor = {}, {}
paused, last_x, last_y, lasttext = false

function UpdateDoors(specificDoor)
	playerCoords = GetEntityCoords(PlayerPedId())
	for doorID, data in pairs(Config.DoorList) do
		if (not specificDoor or doorID == specificDoor) then
			if data.doors then
				for k,v in pairs(data.doors) do
					if #(playerCoords - v.objCoords) < 30 then Wait(1)
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
						if data.delete then
							SetEntityAsMissionEntity(v.object, 1, 1)
							DeleteObject(v.object)
							v.object = nil
						end
						if v.object then
							v.doorHash = 'l_'..doorID..'_'..k
							if not IsDoorRegisteredWithSystem(v.doorHash) then
								AddDoorToSystem(v.doorHash, v.objHash, v.objCoords, false, false, false)
								nearbyDoors[doorID] = true
								if data.locked then
									DoorSystemSetDoorState(v.doorHash, 4, false, false) DoorSystemSetDoorState(v.doorHash, 1, false, false)
								else
									DoorSystemSetDoorState(v.doorHash, 0, false, false) if data.oldMethod then FreezeEntityPosition(v.object, false) end
								end
							end
						end
					elseif v.object then RemoveDoorFromSystem(v.doorHash) nearbyDoors[doorID] = nil end
				end
			elseif not data.doors then
				if #(playerCoords - data.objCoords) < 30 then Wait(2)
					if data.slides then data.object = GetClosestObjectOfType(data.objCoords, 5.0, data.objHash, false, false, false) else
						data.object = GetClosestObjectOfType(data.objCoords, 1.0, data.objHash, false, false, false)
					end
					if data.delete then
						SetEntityAsMissionEntity(data.object, 1, 1)
						DeleteObject(data.object)
						data.object = nil
					end
					if data.object then
						data.doorHash = 'l_'..doorID
						if not IsDoorRegisteredWithSystem(data.doorHash) then
							AddDoorToSystem(data.doorHash, data.objHash, data.objCoords, false, false, false)
							nearbyDoors[doorID] = true
							if data.locked then
								DoorSystemSetDoorState(data.doorHash, 4, false, false) DoorSystemSetDoorState(data.doorHash, 1, false, false)
							else
								DoorSystemSetDoorState(data.doorHash, 0, false, false) if data.oldMethod then FreezeEntityPosition(data.object, false) end
							end
						end
					end
				elseif data.object then RemoveDoorFromSystem(data.doorHash) nearbyDoors[doorID] = false end
			end
			-- set text coords
			if not data.setText and data.doors then
				for k,v in pairs(data.doors) do
					if k == 1 and DoesEntityExist(v.object) then
						data.textCoords = v.objCoords
					elseif k == 2 and DoesEntityExist(v.object) and data.textCoords then
						local textDistance = data.textCoords - v.objCoords
						data.textCoords = (data.textCoords - (textDistance / 2))
						data.setText = true
					end
					if k == 2 and data.textCoords and data.slides then
						if GetEntityHeightAboveGround(v.object) < 1 then
							data.textCoords = vector3(data.textCoords.x, data.textCoords.y, data.textCoords.z+1.2)
						end
					end
				end
			elseif not data.setText and not data.doors and DoesEntityExist(data.object) then
				if data.garage == true then
					data.textCoords = data.objCoords
					data.setText = true
				else
					data.textCoords = SetTextCoords(data)
					data.setText = true
				end
				if data.slides then
					if GetEntityHeightAboveGround(data.object) < 1 then
						data.textCoords = vector3(data.textCoords.x, data.textCoords.y, data.textCoords.z+1.6)
					end
				end
			end
		end
	end
	doorCount = DoorSystemGetSize()
	lastCoords = playerCoords
end

function DoorLoop()
	Framework.TriggerServerCallback('nui_doorlock:getDoorList', function(doorList)
		Config.DoorList = doorList
		UpdateDoors()
		while Framework.PlayerLoaded do
			playerCoords = GetEntityCoords(PlayerPedId())
			local doorSleep = 1000
			if not closestDoor.id then
				local distance = #(playerCoords - lastCoords)
				if distance > 30 then
					UpdateDoors()
				else
					closestDoor.distance = 30
					for k in pairs(nearbyDoors) do
						local door = Config.DoorList[k]
						if door.setText and door.textCoords then
							distance = #(door.textCoords - playerCoords)
							if distance < closestDoor.distance or 10 then
								if distance < door.maxDistance then
									closestDoor = {distance = distance, id = k, data = door}
									doorSleep = 0
								end
							end
						end
						Wait(5)
					end
				end
			end
			if closestDoor.id then
				while true do
					if not paused and IsPauseMenuActive() then SendNUIMessage ({type = "hide"}) paused = true 
					elseif paused then Wait(20)
						if not IsPauseMenuActive() then lasttext, paused = '', false end
					else
						playerCoords = GetEntityCoords(PlayerPedId())
						closestDoor.distance = #(closestDoor.data.textCoords - playerCoords)
						if closestDoor.distance < closestDoor.data.maxDistance then
							if not closestDoor.data.doors then
								local doorState = DoorSystemGetDoorState(closestDoor.data.doorHash)
								if closestDoor.data.locked and doorState ~= 1 then
									Draw3dNUI(closestDoor.data.textCoords, 'Locking')
								elseif not closestDoor.data.locked then
									if Config.ShowUnlockedText then Draw3dNUI(closestDoor.data.textCoords, 'Unlocked') else if isDrawing then SendNUIMessage ({type = "hide"}) isDrawing = false end end
								else
									Draw3dNUI(closestDoor.data.textCoords, 'Locked')
								end
							else
								local door = {}
								local state = {}
								door[1] = closestDoor.data.doors[1]
								door[2] = closestDoor.data.doors[2]
								state[1] = DoorSystemGetDoorState(door[1].doorHash)
								state[2] = DoorSystemGetDoorState(door[2].doorHash)
								
								if closestDoor.data.locked and (state[1] ~= 1 or state[2] ~= 1) then
									Draw3dNUI(closestDoor.data.textCoords, 'Locking')
								elseif not closestDoor.data.locked then
									if Config.ShowUnlockedText then Draw3dNUI(closestDoor.data.textCoords, 'Unlocked') else if isDrawing then SendNUIMessage ({type = "hide"}) isDrawing = false end end
								else
									Draw3dNUI(closestDoor.data.textCoords, 'Locked')
								end
							end
						else
							if closestDoor.distance > closestDoor.data.maxDistance and isDrawing then
								SendNUIMessage ({type = "hide"}) isDrawing = false
							end
							break
						end
						Wait(5)
					end
				end
				closestDoor = {}
				doorSleep = 5
			end
			Wait(doorSleep)
		end
	end)
end

function DrawInfos(text)
	SetTextColour(255, 255, 255, 255)   -- Color
	SetTextFont(4)					  -- Font
	SetTextScale(0.4, 0.4)			  -- Scale
	SetTextWrap(0.0, 1.0)			   -- Wrap the text
	SetTextCentre(false)				-- Align to center(?)
	SetTextDropshadow(0, 0, 0, 0, 255)  -- Shadow. Distance, R, G, B, Alpha.
	SetTextEdge(50, 0, 0, 0, 255)	   -- Edge. Width, R, G, B, Alpha.
	SetTextOutline()					-- Necessary to give it an outline.
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.015, 0.71)			   -- Position
end

function Draw3dNUI(coords, text)
	local _, x, y = GetScreenCoordFromWorldCoord(coords.x,coords.y,coords.z)
	if x ~= last_x or y ~= last_y or text ~= lasttext then
		isDrawing = true
		SendNUIMessage({type = "display", x = x, y = y, text = text})
		last_x, last_y, lasttext = x, y, text
		Wait(1)
	end
end

function PlaySound(door, src)
	local origin
	if src and src ~= PlayerPedId() then src = NetworkGetEntityFromNetworkId(src) end
	if not src then origin = door.textCoords elseif src == PlayerPedId() then origin = playerCoords else origin = NetworkGetPlayerCoords(src) end
	local distance = #(playerCoords - origin)
	if distance < 10 then
		if not door.audioLock then
			if door.audioRemote then
				door.audioLock = {['file'] = 'button-remote.ogg', ['volume'] = 0.08}
				door.audioUnlock = {['file'] = 'button-remote.ogg', ['volume'] = 0.08}
			else
				door.audioLock = {['file'] = 'door-bolt-4.ogg', ['volume'] = 0.1}
				door.audioUnlock = {['file'] = 'door-bolt-4.ogg', ['volume'] = 0.1}
			end
		end
		local sfx_level = GetProfileSetting(300)
		if door.locked then SendNUIMessage ({type = 'audio', audio = door.audioLock, distance = distance, sfx = sfx_level})
		else SendNUIMessage ({type = 'audio', audio = door.audioUnlock, distance = distance, sfx = sfx_level}) end
	end
end

function SetTextCoords(data)
	local minDimension, maxDimension = GetModelDimensions(data.objHash)
	local dimensions = maxDimension - minDimension
	local dx, dy = tonumber(dimensions.x), tonumber(dimensions.y)
	if dy <= -1 or dy >= 1 then dx = dy end
	if data.fixText then
		return GetOffsetFromEntityInWorldCoords(data.object, dx/2, 0, 0)
	else
		return GetOffsetFromEntityInWorldCoords(data.object, -dx/2, 0, 0)
	end
end

function Raycast()
	local offset = GetOffsetFromEntityInWorldCoords(GetCurrentPedWeaponEntityIndex(PlayerPedId()), 0, 0, -0.01)
	local direction = GetGameplayCamRot()
	direction = vector2(direction.x * math.pi / 180.0, direction.z * math.pi / 180.0)
	local num = math.abs(math.cos(direction.x))
	direction = vector3((-math.sin(direction.y) * num), (math.cos(direction.y) * num), math.sin(direction.x))
	local destination = vector3(offset.x + direction.x * 30, offset.y + direction.y * 30, offset.z + direction.z * 30)
	local rayHandle, result, hit, endCoords, surfaceNormal, entityHit = StartShapeTestLosProbe(offset, destination, -1, PlayerPedId(), 0)
	repeat
		result, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
		Wait(1)
	until result ~= 1
	if GetEntityType(entityHit) == 3 then return hit, entityHit else return false end
end

function round(num, decimal)
	local mult = 10^(decimal)
	return math.floor(num * mult + 0.5) / mult
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function dooranim()
	CreateThread(function()
		loadAnimDict("anim@heists@keycard@") 
		TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
		Wait(550)
		ClearPedTasks(PlayerPedId())
	end)
end

function debug(doorID, data)
	if GetDistanceBetweenCoords(playerCoords, data.textCoords) < 3 then
		for k,v in pairs(data) do
			print(  ('%s = %s'):format(k, v) )
		end
		if data.doors then
			for k, v in pairs(data.doors) do
				print('\nCurrent Heading '..k..': '..GetEntityHeading(v.object))
				print('Current Coords '..k..': '..GetEntityCoords(v.object))
			end
		else
			print('\nCurrent Heading: '..GetEntityHeading(data.object))
			print('Current Coords: '..GetEntityCoords(data.object))
		end
	end
end