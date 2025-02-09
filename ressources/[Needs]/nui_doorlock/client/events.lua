

RegisterNetEvent('nui_doorlock:setState')
AddEventHandler('nui_doorlock:setState', function(sid, doorID, locked, src)
	local serverid = GetPlayerServerId(PlayerId())
	if sid == serverid then dooranim() end
	if Config.DoorList[doorID] then
		Config.DoorList[doorID].locked = locked
		UpdateDoors(doorID)
		while true do
			Wait(5)
			if Config.DoorList[doorID].doors then
				for k, v in pairs(Config.DoorList[doorID].doors) do
					if not IsDoorRegisteredWithSystem(v.doorHash) then return end -- If door is not registered end the loop
					v.currentHeading = GetEntityHeading(v.object)
					v.doorState = DoorSystemGetDoorState(v.doorHash)
					if Config.DoorList[doorID].slides then
						if Config.DoorList[doorID].locked then
							DoorSystemSetDoorState(v.doorHash, 1, false, false) -- Set to locked
							DoorSystemSetAutomaticDistance(v.doorHash, 0.0, false, false)
							if k == 2 then PlaySound(Config.DoorList[doorID], src) return end -- End the loop
						else
							DoorSystemSetDoorState(v.doorHash, 0, false, false) -- Set to unlocked
							DoorSystemSetAutomaticDistance(v.doorHash, 30.0, false, false)
							if k == 2 then PlaySound(Config.DoorList[doorID], src) return end -- End the loop
						end
					elseif Config.DoorList[doorID].locked and (v.doorState == 4) then
						if Config.DoorList[doorID].oldMethod then FreezeEntityPosition(v.object, true) end
						DoorSystemSetDoorState(v.doorHash, 1, false, false) -- Set to locked
						if Config.DoorList[doorID].doors[1].doorState == Config.DoorList[doorID].doors[2].doorState then PlaySound(Config.DoorList[doorID], src) return end -- End the loop
					elseif not Config.DoorList[doorID].locked then
						if Config.DoorList[doorID].oldMethod then FreezeEntityPosition(v.object, false) end
						DoorSystemSetDoorState(v.doorHash, 0, false, false) -- Set to unlocked
						if Config.DoorList[doorID].doors[1].doorState == Config.DoorList[doorID].doors[2].doorState then PlaySound(Config.DoorList[doorID], src) return end -- End the loop
					else
						if round(v.currentHeading, 0) == round(v.objHeading, 0) then
							DoorSystemSetDoorState(v.doorHash, 4, false, false) -- Force to close
						end
					end
				end
			else
				if not IsDoorRegisteredWithSystem(Config.DoorList[doorID].doorHash) then return end -- If door is not registered end the loop
				Config.DoorList[doorID].currentHeading = GetEntityHeading(Config.DoorList[doorID].object)
				Config.DoorList[doorID].doorState = DoorSystemGetDoorState(Config.DoorList[doorID].doorHash)
				if Config.DoorList[doorID].slides then
					if Config.DoorList[doorID].locked then
						DoorSystemSetDoorState(Config.DoorList[doorID].doorHash, 1, false, false) -- Set to locked
						DoorSystemSetAutomaticDistance(Config.DoorList[doorID].doorHash, 0.0, false, false)
						PlaySound(Config.DoorList[doorID], src)
						return -- End the loop
					else
						DoorSystemSetDoorState(Config.DoorList[doorID].doorHash, 0, false, false) -- Set to unlocked
						DoorSystemSetAutomaticDistance(Config.DoorList[doorID].doorHash, 30.0, false, false)
						PlaySound(Config.DoorList[doorID], src)
						return -- End the loop
					end
				elseif Config.DoorList[doorID].locked and (Config.DoorList[doorID].doorState == 4) then
					if Config.DoorList[doorID].oldMethod then FreezeEntityPosition(Config.DoorList[doorID].object, true) end
					DoorSystemSetDoorState(Config.DoorList[doorID].doorHash, 1, false, false) -- Set to locked
					PlaySound(Config.DoorList[doorID], src)
					return -- End the loop
				elseif not Config.DoorList[doorID].locked then
					if Config.DoorList[doorID].oldMethod then FreezeEntityPosition(Config.DoorList[doorID].object, false) end
					DoorSystemSetDoorState(Config.DoorList[doorID].doorHash, 0, false, false) -- Set to unlocked
					PlaySound(Config.DoorList[doorID], src)
					return -- End the loop
				else
					if round(Config.DoorList [doorID].currentHeading, 0) == round(Config.DoorList[doorID].objHeading, 0) then
						DoorSystemSetDoorState(Config.DoorList[doorID].doorHash, 4, false, false) -- Force to close
					end
				end
			end
		end
	end
end)

RegisterNetEvent('nui_doorlock:newDoorSetup')
AddEventHandler('nui_doorlock:newDoorSetup', function(args)
	if not args[1] then
		receivedDoorData = false
		SetNuiFocus(true, true)
		SendNUIMessage({type = "newDoorSetup", enable = true})
		while receivedDoorData == false do Wait(5) DisableAllControlActions(0) end
	end
	--if not args[1] then print('/newdoor [doortype] [locked] [jobs]\nDoortypes: door, sliding, garage, double, doublesliding\nLocked: true or false\nJobs: Up to four can be added with the command') return end
	if arg then doorType = arg.doortype else doorType = args[1] end
	if arg then doorLocked = arg.doorlocked else doorLocked = not not args[1] end
	local validTypes = {['door']=true, ['sliding']=true, ['garage']=true, ['double']=true, ['doublesliding']=true}
	if not validTypes[doorType] then print(doorType.. ' is not a valid doortype') return end
	if arg and arg.item == '' and arg.job1 == '' then print('You must enter either a job or item for lock authorisation') return end
	if args[7] then print('You can only set four authorised jobs - if you want more, add them to the config later') return end
	if doorType == 'door' or doorType == 'sliding' or doorType == 'garage' then
		local entity, coords, heading, model = nil, nil, nil, nil
		local result = false
		print('Aim at your desired door and press left mouse button')
		while true do
			if IsPlayerFreeAiming(PlayerId()) then
				local result, object = Raycast()
				if result and object ~= entity then
					SetEntityDrawOutline(entity, false)
					SetEntityDrawOutline(object, true)
					entity = object
					coords = GetEntityCoords(entity)
					model = GetEntityModel(entity)
					heading = GetEntityHeading(entity)
				end
			else Wait(1) end
			if result then DrawInfos("Coordinates: " .. coords .. "\nHeading: " .. heading .. "\nHash: " .. model)
		else DrawInfos("Aim at your desired door and shoot") end
			if entity and IsControlPressed(0, 24) then break end
		end
		SetEntityDrawOutline(entity, false)
		if not model or model == 0 then print('Did not receive a model hash\nIf the door is transparent, make sure you aim at the frame') return end
		local result, door = DoorSystemFindExistingDoor(coords.x, coords.y, coords.z, model)
		if result then return print('This door is already registered') end
		local jobs = {}
		if args[3] then
			jobs[1] = args[3]
			jobs[2] = args[4]
			jobs[3] = args[5]
			jobs[4] = args[6]
		else
			if arg.job1 ~= '' then jobs[1] = arg.job1 end
			if arg.job2 ~= '' then jobs[2] = arg.job2 end
			if arg.job3 ~= '' then jobs[3] = arg.job3 end
			if arg.job4 ~= '' then jobs[4] = arg.job4 end
			if arg.item ~= '' then item = arg.item end
		end
		local maxDistance, slides, garage = 2.0, false, false
		if doorType == 'sliding' then slides = true
		elseif doorType == 'garage' then slides, garage = 6.0, true, true end
		if slides then maxDistance = 6.0 end
		local doorHash = 'l_'..#Config.DoorList + 1
		AddDoorToSystem(doorHash, model, coords, false, false, false)
		DoorSystemSetDoorState(doorHash, 4, false, false)
		coords = GetEntityCoords(entity)
		heading = GetEntityHeading(entity)
		RemoveDoorFromSystem(doorHash)
		if arg then doorname = arg.doorname end
		TriggerServerEvent('nui_doorlock:newDoorCreate', arg.configname, model, heading, coords, jobs, item, doorLocked, maxDistance, slides, garage, false, doorname)
		print('Successfully sent door data to the server')
	elseif doorType == 'double' or doorType == 'doublesliding' then
		local entity, coords, heading, model = {}, {}, {}, {}
		local result = false
		print('Aim at each desired door and press left mouse button')
		for i=1, 2 do
			while true do
				if IsPlayerFreeAiming(PlayerId()) then
					local result, object = Raycast()
					if result and object ~= entity[i] then
						SetEntityDrawOutline(entity[i], false)
						SetEntityDrawOutline(object, true)
						entity[i] = object
						coords[i] = GetEntityCoords(object)
						model[i] = GetEntityModel(object)
						heading[i] = GetEntityHeading(object)
					end
				else Wait(1) end
				if result then DrawInfos("Coordinates: " .. coords[i] .. "\nHeading: " .. heading[i] .. "\nHash: " .. model[i])
			else DrawInfos("Aim at your desired door and shoot") end
				if entity[i] and IsControlPressed(0, 24) then break end
			end
			Wait(200)
		end
		SetEntityDrawOutline(entity[1], false)
		SetEntityDrawOutline(entity[2], false)
		if not model[1] or model[1] == 0 or not model[2] or model[2] == 0 then print('Did not receive a model hash\nIf the door is transparent, make sure you aim at the frame') return end
		if entity[1] == entity[2] then print('Can not add double door if entities are the same') return end
		for i=1, 2 do
			local result, door = DoorSystemFindExistingDoor(coords[i].x, coords[i].y, coords[i].z, model[i])
			if result then return print('This door is already registered') end
		end
		local jobs = {}
		if args[3] then
			jobs[1] = args[3]
			jobs[2] = args[4]
			jobs[3] = args[5]
			jobs[4] = args[6]
		else
			if arg.job1 ~= '' then jobs[1] = arg.job1 end
			if arg.job2 ~= '' then jobs[2] = arg.job2 end
			if arg.job3 ~= '' then jobs[3] = arg.job3 end
			if arg.job4 ~= '' then jobs[4] = arg.job4 end
			if arg.item ~= '' then item = arg.item end
		end
		local maxDistance, slides, garage = 2.5, false, false
		if doorType == 'sliding' or doorType == 'doublesliding' then slides = true end
		if slides then maxDistance = 6.0 end

		local doors = #Config.DoorList + 1
		local doorHash = {}
		doorHash[1] = 'l_'..doors..'_'..'1'
		doorHash[2] = 'l_'..doors..'_'..'2'
		for i=1, #doorHash do
			AddDoorToSystem(doorHash[i], model[i], coords[i], false, false, false)
			DoorSystemSetDoorState(doorHash[i], 4, false, false)
			coords[i] = GetEntityCoords(entity[i])
			heading[i] = GetEntityHeading(entity[i])
			RemoveDoorFromSystem(doorHash[i])
		end
		if arg then doorname = arg.doorname end
		TriggerServerEvent('nui_doorlock:newDoorCreate', arg.configname, model, heading, coords, jobs, item, doorLocked, maxDistance, slides, garage, true, doorname)
		print('Successfully sent door data to the server')
		arg = nil
	end
end)

RegisterNetEvent('nui_doorlock:newDoorAdded')
AddEventHandler('nui_doorlock:newDoorAdded', function(newDoor, doorID, locked)
	Config.DoorList[doorID] = newDoor
	UpdateDoors()
	TriggerEvent('nui_doorlock:setState', GetPlayerServerId(PlayerId()), doorID, locked)
end)
