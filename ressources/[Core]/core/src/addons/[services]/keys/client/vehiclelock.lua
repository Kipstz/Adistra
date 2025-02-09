
RegisterCommand('vehiclelock', function()
    local plyPed = PlayerPedId()
	local myCoords = GetEntityCoords(plyPed)
	local vehicle = nil

	if IsPedInAnyVehicle(plyPed, false) then
		vehicle = GetVehiclePedIsIn(plyPed, false)
	else
		vehicle = Framework.Game.GetClosestVehicle(myCoords)
	end

	Framework.TriggerServerCallback('keys:haveKey', function(haveKey)
		if haveKey then
			local locked = GetVehicleDoorLockStatus(vehicle)

			if not IsPedInAnyVehicle(plyPed) then
				Framework.Game.SpawnObject('p_car_keys_01', vector3(0.0, 0.0, 70.0), function(obj)
					SetEntityCollision(obj, false, false)
					AttachEntityToEntity(obj, plyPed, GetPedBoneIndex(plyPed, 57005), 0.09, 0.03, -0.02, -76.0, 13.0, 28.0, false, true, true, true, 0, true)

					SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
					ClearPedTasks(plyPed)
					TaskTurnPedToFaceEntity(plyPed, vehicle, 500)

					RequestAnimDict("anim@mp_player_intmenu@key_fob@")

					while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
						Wait(10)
					end

					TaskPlayAnim(plyPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 3.0, 3.0, 1000, 16)
					RemoveAnimDict("anim@mp_player_intmenu@key_fob@")
					PlaySoundFromEntity(-1, "Remote_Control_Fob", vehicle, "PI_Menu_Sounds", true, 0)
					Wait(1250)

					DetachEntity(obj, false, false)
					DeleteObject(obj)
				end)
			end

			if locked == 1 or locked == 0 then
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				Framework.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
			elseif locked == 2 then
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				Framework.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
			end
		else
			Framework.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end)

RegisterKeyMapping('vehiclelock', "Ouvrir/Fermer un véhicule", 'keyboard', 'U')