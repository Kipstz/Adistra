Status, isPaused = {}, false

function Status:GetStatus(name, cb)
	for i = 1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end

function Status:GetStatusData(minimal)
	local status = {}

	for i=1, #Status, 1 do
		if minimal then
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				percent = (Status[i].val / Config['status'].StatusMax) * 100
			})
		else
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				color   = Status[i].color,
				visible = Status[i].visible(Status[i]),
				percent = (Status[i].val / Config['status'].StatusMax) * 100
			})
		end
	end

	return status
end

AddEventHandler("status:register", function(name, default, color, tickCallback)
	local status = CreateStatus(name, default, color, tickCallback)
	table.insert(Status, status)
end)

AddEventHandler("status:unregister", function(name)
	for k,v in ipairs(Status) do
		if v.name == name then
			table.remove(Status, k)
			break
		end
	end
end)

RegisterNetEvent('framework:onPlayerLogout')
AddEventHandler('framework:onPlayerLogout', function()
	Status = {}
end)

RegisterNetEvent("status:load")
AddEventHandler("status:load", function(status)
	TriggerEvent("status:loaded")
	for i=1, #Status, 1 do
		for j=1, #status, 1 do
			if Status[i].name == status[j].name then
				Status[i].set(status[j].val)
			end
		end
	end

	CreateThread(function()
		local data = {}
		while Framework.PlayerLoaded do
			for i=1, #Status do
				Status[i].onTick()
				table.insert(data, {
					name = Status[i].name,
					val = Status[i].val,
					percent = (Status[i].val / 1000000) * 100
				})
			end

			table.wipe(data)
			Wait(Config['status'].TickTime)
		end
	end)
end)

RegisterNetEvent("status:set")
AddEventHandler("status:set", function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end
end)

RegisterNetEvent("status:add")
AddEventHandler("status:add", function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end
end)

RegisterNetEvent("status:remove")
AddEventHandler("status:remove", function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end
end)

AddEventHandler("status:get", function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

local IsAnimated = false
local IsAlreadyDrunk = false
local DrunkLevel = -1
local IsAlreadyDrug = false

function DrunkEffect(level, start)
	CreateThread(function()
		local plyPed = PlayerPedId()

		if start then
			DoScreenFadeOut(800)
			Wait(1000)
		end

		if level == 0 then
			Framework.Streaming.RequestAnimSet("move_m@drunk@slightlydrunk")

			SetPedMovementClipset(plyPed, "move_m@drunk@slightlydrunk", true)
			RemoveAnimSet("move_m@drunk@slightlydrunk")
		elseif level == 1 then
			Framework.Streaming.RequestAnimSet("move_m@drunk@moderatedrunk")

			SetPedMovementClipset(plyPed, "move_m@drunk@moderatedrunk", true)
			RemoveAnimSet("move_m@drunk@moderatedrunk")
		elseif level == 2 then
			Framework.Streaming.RequestAnimSet("move_m@drunk@verydrunk")

			SetPedMovementClipset(plyPed, "move_m@drunk@verydrunk", true)
			RemoveAnimSet("move_m@drunk@verydrunk")
		end

		SetTimecycleModifier("spectator5")
		SetPedMotionBlur(plyPed, true)
		SetPedIsDrunk(plyPed, true)

		if start then
			DoScreenFadeIn(800)
		end
	end)
end

function OverdoseEffect()
	CreateThread(function()
		local plyPed = PlayerPedId()

		SetEntityHealth(plyPed, 0)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(plyPed, 0.0)
		SetPedIsDrug(plyPed, false)
		SetPedMotionBlur(plyPed, false)
	end)
end

function StopEffect()
	CreateThread(function()
		local plyPed = PlayerPedId()

		DoScreenFadeOut(800)
		Wait(1000)

		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(plyPed, 0.0)
		SetPedIsDrunk(plyPed, false)
		SetPedMotionBlur(plyPed, false)

		DoScreenFadeIn(800)
	end)
end

RegisterNetEvent('status:resetStatus')
AddEventHandler('status:resetStatus', function()
	for i = 1, #Status, 1 do
		Status[i].reset()
	end
end)

function RegisterStatus(name, default, color, tickCallback)
	local status = CreateStatus(name, default, color, tickCallback)
	table.insert(Status, status)
end

RegisterNetEvent('status:healPlayer')
AddEventHandler('status:healPlayer', function()
	TriggerEvent('status:set', 'hunger', 1000000)
	TriggerEvent('status:set', 'thirst', 1000000)

	local plyPed = PlayerPedId()
	SetEntityHealth(plyPed, GetEntityMaxHealth(plyPed))
end)

CreateThread(function()
	RegisterStatus('hunger', 1000000, '#b51515', function(status)
		status.remove(65)
	end)

	RegisterStatus('thirst', 1000000, '#0172ba', function(status)
		status.remove(65)
	end)

	RegisterStatus('drunk', 0, '#8F15A5', function(status)
		status.remove(1500)
	end)

	RegisterStatus('drug', 0, '#9ec617', function(status)
		status.remove(1500)
	end)

	while true do
		Wait(10000)
		local plyPed = PlayerPedId()
		local prevHealth = GetEntityHealth(plyPed)
		local health = prevHealth;

		if health > 0 then
			Status:GetStatus('hunger', function(status)
				if status.val <= 0 then
					health = health - 1
				end
			end)

			Status:GetStatus('thirst', function(status)
				if status.val <= 0 then
					health = health - 1
				end
			end)

			Status:GetStatus('drunk', function(status)
				if status.val > 0 then
					local start = true

					if IsAlreadyDrunk then
						start = false
					end

					local level = 0

					if status.val <= 250000 then
						level = 0
					elseif status.val <= 500000 then
						level = 1
					else
						level = 2
					end

					if level ~= DrunkLevel then
						DrunkEffect(level, start)
					end

					IsAlreadyDrunk = true
					DrunkLevel = level
				else
					if IsAlreadyDrunk then
						StopEffect()
					end

					IsAlreadyDrunk = false
					DrunkLevel = -1
				end
			end)

			Status:GetStatus('drug', function(status)
				if status.val > 0 then
					if status.val >= 1000000 then
						OverdoseEffect()
					end

					IsAlreadyDrug = true
				else
					if IsAlreadyDrug then
						StopEffect()
					end

					IsAlreadyDrug = false
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(plyPed,  health)
			end
		else
			if IsAlreadyDrunk or IsAlreadyDrug then
				StopEffect()
			end

			IsAlreadyDrunk = false
			IsAlreadyDrug = false
			DrunkLevel = -1
		end
	end
end)

RegisterNetEvent('status:onEat')
AddEventHandler('status:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		CreateThread(function()
			local plyPed = PlayerPedId()
			local plyCoords = GetEntityCoords(plyPed, false)
			local propHash = GetHashKey(prop_name)

			Framework.Game.SpawnObject(propHash, vector3(plyCoords.x, plyCoords.y, plyCoords.z + 0.2), function(object)
				AttachEntityToEntity(prop, plyPed, GetPedBoneIndex(plyPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
				SetModelAsNoLongerNeeded(propHash)

				Framework.Streaming.RequestAnimDict('mp_player_inteat@burger')

				TaskPlayAnim(plyPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
				RemoveAnimDict('mp_player_inteat@burger')
				Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(plyPed)
				DeleteObject(prop)
			end)
		end)
	end
end)

RegisterNetEvent('status:onDrink')
AddEventHandler('status:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		CreateThread(function()
			local plyPed = PlayerPedId()
			local plyCoords = GetEntityCoords(plyPed, false)
			local propHash = GetHashKey(prop_name)

			Framework.Game.SpawnObject(propHash, vector3(plyCoords.x, plyCoords.y, plyCoords.z + 0.2), function(object)
				AttachEntityToEntity(object, plyPed, GetPedBoneIndex(plyPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
				SetModelAsNoLongerNeeded(propHash)

				Framework.Streaming.RequestAnimDict('mp_player_intdrink')

				TaskPlayAnim(plyPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
				RemoveAnimDict('mp_player_intdrink')
				Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(plyPed)
				DeleteObject(object)
			end)
		end)
	end
end)

RegisterNetEvent('status:onDrinkAlcohol')
AddEventHandler('status:onDrinkAlcohol', function()
	if not IsAnimated then
		IsAnimated = true

		CreateThread(function()
			local plyPed = PlayerPedId()
			TaskStartScenarioInPlace(plyPed, "WORLD_HUMAN_DRINKING", 0, true)
			Wait(10000)
			IsAnimated = false
			ClearPedTasksImmediately(plyPed)
		end)
	end
end)

RegisterNetEvent('status:onAdis')
AddEventHandler('status:onAdis', function()
	if not IsAnimated then
		IsAnimated = true

		CreateThread(function()
			local plyPed = PlayerPedId()

			Framework.Streaming.RequestAnimSet("move_m@hipster@a")

			TaskStartScenarioInPlace(plyPed, "WORLD_HUMAN_SMOKING_POT", 0, true)
			Wait(3000)
			IsAnimated = false
			ClearPedTasksImmediately(plyPed)
			SetTimecycleModifier("spectator5")
			SetPedMotionBlur(plyPed, true)
			SetPedMovementClipset(plyPed, "move_m@hipster@a", true)
			RemoveAnimSet("move_m@hipster@a")
			SetPedIsDrunk(plyPed, true)
		end)
	end
end)

-- Update server
CreateThread(function()
	while true do
		Wait(Config['status'].UpdateInterval)
		if Framework.PlayerLoaded then 
			TriggerServerEvent("status:update", Status:GetStatusData(true)) 
		end
	end
end)