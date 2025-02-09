
local Animations = {}

local function startPointing(plyPed)
	Framework.Streaming.RequestAnimDict('anim@mp_point')
	SetPedConfigFlag(plyPed, 36, true)
	TaskMoveNetworkByName(plyPed, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
	RemoveAnimDict('anim@mp_point')
end

local function stopPointing(plyPed)
	RequestTaskMoveNetworkStateTransition(plyPed, 'Stop')

	if not IsPedInjured(plyPed) then
		ClearPedSecondaryTask(plyPed)
	end

	SetPedConfigFlag(plyPed, 36, false)
	ClearPedSecondaryTask(plyPed)
end

CreateThread(function()
	while true do
		wait = 9000
		
		if Animations.crouched or Animations.handsUp or Animations.pointing then
			wait = 9000

			if not IsPedOnFoot(PlayerPedId()) then
				ResetPedMovementClipset(PlayerPedId(), 0.0)
				stopPointing()
				Animations.crouched, Animations.handsUp, Animations.pointing = false, false, false
			elseif Animations.pointing then
				local ped = PlayerPedId()
				local camPitch = GetGameplayCamRelativePitch()

				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end

				camPitch = (camPitch + 70.0) / 112.0

				local camHeading = GetGameplayCamRelativeHeading()
				local cosCamHeading = Cos(camHeading)
				local sinCamHeading = Sin(camHeading)

				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end

				camHeading = (camHeading + 180.0) / 360.0
				local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
				local rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7))

				SetTaskMoveNetworkSignalFloat(ped, 'Pitch', camPitch)
				SetTaskMoveNetworkSignalFloat(ped, 'Heading', (camHeading * -1.0) + 1.0)
				SetTaskMoveNetworkSignalBool(ped, 'isBlocked', blocked)
				SetTaskMoveNetworkSignalBool(ped, 'isFirstPerson', N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
			end
		end

		Wait(wait)
	end
end)

RegisterCommand('crouch', function()
	local plyPed = PlayerPedId()
	if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) and IsPedOnFoot(plyPed) then
		Animations.crouched = not Animations.crouched

		if Animations.crouched then 
			Framework.Streaming.RequestAnimSet('move_ped_crouched')

			SetPedMovementClipset(plyPed, 'move_ped_crouched', 0.25)
			RemoveAnimSet('move_ped_crouched')
		else
			ResetPedMovementClipset(plyPed, 0.0)
		end
	end
end)

RegisterKeyMapping('crouch', "S'accroupir", 'keyboard', "NUMPADENTER")

RegisterCommand('handsup', function()
	local plyPed = PlayerPedId()
	if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) and IsPedOnFoot(plyPed) then
		if Animations.pointing then
			Animations.pointing = false
		end

		Animations.handsUp = not Animations.handsUp
		DecorSetBool(PlayerPedId(), 'handsUp', Animations.handsUp)

		if Animations.handsUp then
			Framework.Streaming.RequestAnimDict('random@mugging3')
			TaskPlayAnim(plyPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8.0, -1, 49, 0.0, false, false, false)
			RemoveAnimDict('random@mugging3')
		else
			ClearPedSecondaryTask(plyPed)
		end
	end
end)

RegisterKeyMapping('handsup', "Lever les Mains", 'keyboard', "OEM_3")

RegisterCommand('pointing', function()
	local plyPed = PlayerPedId()
	if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) and IsPedOnFoot(plyPed) then
		if Animations.handsUp then
			Animations.handsUp = false
		end

		Animations.pointing = not Animations.pointing

		if Animations.pointing then
			startPointing(plyPed)
		else
			stopPointing(plyPed)
		end
	end
end)

RegisterKeyMapping('pointing', "Pointer du Doigt", 'keyboard', "B")