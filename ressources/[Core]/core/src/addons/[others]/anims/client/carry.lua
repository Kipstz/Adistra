
Anims.carryingBackInProgress = false;

Anims.carryParams = {
    lib               = 'missfinale_c2mcs_1',
    anim1             = 'fin_c2_mcs_1_camman',
    lib2              = 'nm',
    anim2             = 'firemans_carry',
    distans           = 0.15,
    distans2          = 0.27,
    height            = 0.63,
    spin              = 0.0,
    length            = 100000,
    controlFlagMe     = 49,
    controlFlagTarget = 33,
    animFlagTarget    = 1
}

RegisterNetEvent('animCarry:syncTarget')
AddEventHandler('animCarry:syncTarget', function(target, params)
	local plyPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	Anims.carryingBackInProgress = true;

	RequestAnimDict(params.lib2)
	while not HasAnimDictLoaded(params.lib2) do Wait(10) end

	if params.spin == nil then params.spin = 180.0 end
	if params.controlFlagTarget == nil then params.controlFlagTarget = 0 end

	AttachEntityToEntity(plyPed, targetPed, 0, params.distans2, params.distans, params.height, 0.5, 0.5, params.spin, false, false, false, false, 2, false)
	TaskPlayAnim(plyPed, params.lib2, params.anim2, 8.0, -8.0, params.length, params.controlFlagTarget, 0, false, false, false)
end)

RegisterNetEvent('animCarry:syncMe')
AddEventHandler('animCarry:syncMe', function(params)
	local plyPed = PlayerPedId()

	RequestAnimDict(params.lib)
	while not HasAnimDictLoaded(params.lib) do Wait(10) end

	Wait(500)
	if params.controlFlagMe == nil then params.controlFlagMe = 0 end

	TaskPlayAnim(plyPed, params.lib, params.anim1, 8.0, -8.0, params.length, params.controlFlagMe, 0, false, false, false)
	Wait(params.length)
end)

RegisterNetEvent('animCarry:stop')
AddEventHandler('animCarry:stop', function()
    local plyPed = PlayerPedId()

	Anims.carryingBackInProgress = false;

	ClearPedSecondaryTask(plyPed)
	DetachEntity(plyPed, true, false)
end)

RegisterCommand("porter",function(source, args)
	local plyPed = PlayerPedId()

	if not Anims.carryingBackInProgress then
		if not IsEntityVisible(plyPed) then
			if not AdminMenu.isfreecam then
				TriggerServerEvent('carry:ban')
				return
			end
		end
		Anims.carryingBackInProgress = true;

        local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()
	
        if closestPlayer ~= -1 and closestDist <= 3 then
            local target = GetPlayerServerId(closestPlayer)

			TriggerServerEvent('animCarry:sync', target, Anims.carryParams)
		else
			Framework.ShowNotification("~r~Aucun joueur à proximité !~s~")
		end
	else
		Anims.carryingBackInProgress = false;

		ClearPedSecondaryTask(plyPed)
		DetachEntity(plyPed, true, false)

		local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()
        local target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("animCarry:stop", target)
	end
end, false)