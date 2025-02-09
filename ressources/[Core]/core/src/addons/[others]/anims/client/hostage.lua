
Anims.hostageAllowedWeapons = {
	`WEAPON_PISTOL`,
	`WEAPON_PISTOL_MK2`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_PISTOL50`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_SNSPISTOL_MK2`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_REVOLVER`,
	`WEAPON_REVOLVER_MK2`,
	`WEAPON_DOUBLEACTION`,
	`WEAPON_APPISTOL`
}

Anims.hostageParams = {
	lib               = 'anim@gangops@hostage@',
	anim1             = 'perp_idle',
	lib2              = 'anim@gangops@hostage@',
	anim2             = 'victim_idle',
	distans           = 0.11,
	distans2          = -0.24,
	height            = 0.0,
	spin              = 0.0,
	length            = 100000,
	controlFlagMe     = 49,
	controlFlagTarget = 49,
	animFlagTarget    = 50,
	attachFlag        = true
}

Anims.releaseHostageParams = {
	lib               = 'reaction@shove',
	anim1             = 'shove_var_a',
	lib2              = 'reaction@shove',
	anim2             = 'shoved_back',
	distans           = 0.11,
	distans2          = -0.24,
	height            = 0.0,
	spin              = 0.0,
	length            = 100000,
	controlFlagMe     = 120,
	controlFlagTarget = 0,
	animFlagTarget    = 1,
	attachFlag        = false
}

Anims.killHostageParams = {
	lib               = 'anim@gangops@hostage@',
	anim1             = 'perp_fail',
	lib2              = 'anim@gangops@hostage@',
	anim2             = 'victim_fail',
	distans           = 0.11,
	distans2          = -0.24,
	height            = 0.0,
	spin              = 0.0,
	length            = 0.2,
	controlFlagMe     = 168,
	controlFlagTarget = 0,
	animFlagTarget    = 1,
	attachFlag        = false
}

function Anims:releaseHostage()
	local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDist <= 3 then
		local target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent('animHostage:sync', Anims.releaseHostageParams)
	end
end

function Anims:killHostage()
	local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

	if closestDistance ~= -1 and closestDistance <= 3 then
		local target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent('animHostage:sync', Anims.killHostageParams)
	end
end

Anims.holdingHostage = false;
Anims.holdingHostageInProgress = false;
Anims.beingHeldHostage = false;

Anims.takeHostageAnimNamePlaying = '';
Anims.takeHostageAnimDictPlaying = '';

RegisterCommand('otage', function()
	if not ZoneSafe.isInZone then
		local plyPed = PlayerPedId()
		local currentWeapon = GetSelectedPedWeapon(plyPed)
		Anims.canTakeHostage, Anims.foundWeapon = false, false
	
		ClearPedSecondaryTask(plyPed)
		DetachEntity(plyPed, true, false)
	
		for i = 1, #Anims.hostageAllowedWeapons do
			if currentWeapon == Anims.hostageAllowedWeapons[i] then
				Anims.canTakeHostage = true;
				Anims.foundWeapon = Anims.hostageAllowedWeapons[i]
			end
		end
	
		if not Anims.foundWeapon then
			for i = 1, #Anims.hostageAllowedWeapons do
				if HasPedGotWeapon(plyPed, Anims.hostageAllowedWeapons[i], false) then
					if GetAmmoInPedWeapon(plyPed, Anims.hostageAllowedWeapons[i]) > 0 then
						Anims.canTakeHostage = true;
						Anims.foundWeapon = Anims.hostageAllowedWeapons[i]
						break
					end
				end
			end
		end
	
		if Anims.canTakeHostage then
			if not Anims.holdingHostageInProgress then
				local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()
	
				if closestPlayer ~= -1 and closestDist <= 3 then
					local target = GetPlayerServerId(closestPlayer)
	
					if IsPlayerDead(closestPlayer) then
						Framework.ShowNotification("~r~Vous ne pouvez prendre en otage ce joueur !~s~")
					else	
						SetCurrentPedWeapon(plyPed, Anims.foundWeapon, true)

						Anims.holdingHostageInProgress = true;
						Anims.holdingHostage = true;

						TriggerServerEvent('animHostage:sync', target, Anims.hostageParams)
					end
				else
					Framework.ShowNotification("~r~Aucun joueur à proximité !~s~")
				end
			end
		else
			Framework.ShowNotification("~r~Vous avez besoin d'une arme pour prendre un otage !~s~")
		end
	else
		Framework.ShowNotification("~r~Vous ne pouvez pas faire cela en Zone-Safe !~s~")
	end
end, false)

RegisterNetEvent('animHostage:syncTarget')
AddEventHandler('animHostage:syncTarget', function(target, params)
	local plyPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	if Anims.holdingHostageInProgress then 
		Anims.holdingHostageInProgress = false;
	else 
		Anims.holdingHostageInProgress = true;
	end

	Anims.beingHeldHostage = true;

	RequestAnimDict(params.lib)
	while not HasAnimDictLoaded(params.lib) do Wait(10) end

	if params.spin == nil then params.spin = 180.0 end
    if params.controlFlagTarget == nil then params.controlFlagTarget = 0 end

	if params.attachFlag then AttachEntityToEntity(plyPed, targetPed, 0, params.distans2, params.distans, params.height, 0.5, 0.5, params.spin, false, false, false, false, 2, false) end

	if params.anim2 == "victim_fail" then 
		SetEntityHealth(plyPed, 0)
		DetachEntity(plyPed, true, false)
		TaskPlayAnim(plyPed, params.lib, params.anim2, 8.0, -8.0, params.length, params.controlFlagTarget, 0, false, false, false)

		Anims.beingHeldHostage = false;
		Anims.holdingHostageInProgress = false;
	elseif params.anim2 == "shoved_back" then 
		Anims.holdingHostageInProgress = false;

		DetachEntity(plyPed, true, false)
		TaskPlayAnim(plyPed, params.lib, params.anim2, 8.0, -8.0, params.length, params.controlFlagTarget, 0, false, false, false)

		Anims.beingHeldHostage = false;
	else
		TaskPlayAnim(plyPed, params.lib, params.anim2, 8.0, -8.0, params.length, params.controlFlagTarget, 0, false, false, false)	
	end

	Anims.takeHostageAnimNamePlaying = params.anim2;
	Anims.takeHostageAnimDictPlaying = params.lib;
	Anims.takeHostageControlFlagPlaying = params.controlFlagTarget;
end)

RegisterNetEvent('animHostage:syncMe')
AddEventHandler('animHostage:syncMe', function(params)
	local plyPed = PlayerPedId()
	ClearPedSecondaryTask(plyPed)

	RequestAnimDict(params.lib2)
	while not HasAnimDictLoaded(params.lib2) do Wait(10) end

	if params.controlFlagMe == nil then params.controlFlagMe = 0 end

	TaskPlayAnim(plyPed, params.lib2, params.anim1, 8.0, -8.0, params.length, params.controlFlagMe, 0, false, false, false)

	Anims.takeHostageAnimNamePlaying = params.anim1
	Anims.takeHostageAnimDictPlaying = params.lib2
	Anims.takeHostageControlFlagPlaying = params.controlFlagMe

	if params.anim1 == "perp_fail" then 
		SetPedShootsAtCoord(plyPed, 0.0, 0.0, 0.0, 0)
		Anims.holdingHostageInProgress = false;
	end

	if params.anim1 == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(plyPed)
		Anims.holdingHostageInProgress = false;
	end
end)

RegisterNetEvent('animHostage:cl_stop')
AddEventHandler('animHostage:cl_stop', function()
    local plyPed = PlayerPedId()

	Anims.holdingHostageInProgress = false;
	Anims.beingHeldHostage = false; 
	Anims.holdingHostage = false;

	ClearPedSecondaryTask(plyPed)
	DetachEntity(plyPed, true, false)
end)

CreateThread(function()
	while true do
        wait = 5000

		if (Anims.holdingHostage or Anims.beingHeldHostage) and Anims.takeHostageAnimDictPlaying ~= '' and Anims.takeHostageAnimNamePlaying ~= '' then
            wait = 100

            local plyPed = PlayerPedId()

			while not IsEntityPlayingAnim(plyPed, Anims.takeHostageAnimDictPlaying, Anims.takeHostageAnimNamePlaying, 3) do
				TaskPlayAnim(plyPed, Anims.takeHostageAnimDictPlaying, Anims.takeHostageAnimNamePlaying, 8.0, -8.0, 100000, 0, 0, false, false, false)
				Wait(1)
			end
		end

        Wait(wait)
	end
end)

CreateThread(function()
	while true do
        wait = 5000

		if Anims.holdingHostage then
            wait = 5

			local plyPed = PlayerPedId()
			local plyCoords = GetEntityCoords(plyPed)

			if IsEntityDead(plyPed) then
				Anims.holdingHostage = false;
				Anims.holdingHostageInProgress = false;

				local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDist <= 3 then
					local target = GetPlayerServerId(closestPlayer)
					TriggerServerEvent('animHostage:stop', target)
				end

				Wait(100)
				Anims:releaseHostage()
			end

			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisablePlayerFiring(plyPed, true)

			Framework.Game.Utils.DrawText3D(plyCoords, 'Appuyer sur [G] pour relâcher, [H] pour tuer', 0.5)

			if IsDisabledControlJustPressed(0, 47) then
				Anims.holdingHostage = false;
				Anims.holdingHostageInProgress = false;

				local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDist <= 3 then
					local target = GetPlayerServerId(closestPlayer)
					TriggerServerEvent('animHostage:stop', target)
				end

				Wait(100)
				Anims:releaseHostage()
			elseif IsDisabledControlJustPressed(0, 74) then
				Anims.holdingHostage = false
				Anims.holdingHostageInProgress = false

				local closestPlayer, closestDist = Framework.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDist <= 3 then
					local target = GetPlayerServerId(closestPlayer)
					TriggerServerEvent('animHostage:stop', target)
				end

				Anims:killHostage()
			end
		end

		if Anims.beingHeldHostage then
            wait = 1
            
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
			DisableControlAction(0, 22, true) -- disable jump
			DisableControlAction(0, 32, true) -- disable move up
			DisableControlAction(0, 268, true)
			DisableControlAction(0, 33, true) -- disable move down
			DisableControlAction(0, 269, true)
			DisableControlAction(0, 34, true) -- disable move left
			DisableControlAction(0, 270, true)
			DisableControlAction(0, 35, true) -- disable move right
			DisableControlAction(0, 271, true)
		end

        Wait(wait)
	end
end)

