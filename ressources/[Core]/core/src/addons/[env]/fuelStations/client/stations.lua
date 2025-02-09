local UI = { 
	x =  0.000, y = -0.001
}

FuelStations.isNearPump, FuelStations.isFueling  = false, false
FuelStations.currentFuel, FuelStations.currentCost, FuelStations.currentCash = 0.0, 0.0, 0
FuelStations.fuelSynced = false
FuelStations.inBlacklisted = false

CreateThread(function()
	while true do
		wait = 2000

		local plyPed = PlayerPedId()

		if IsPedInAnyVehicle(plyPed) then
            wait = 1000

			local vehicle = GetVehiclePedIsIn(plyPed)

			if Config['fuelStations'].Blacklist[GetEntityModel(vehicle)] then
				FuelStations.inBlacklisted = true
			else
				FuelStations.inBlacklisted = false
			end

			if not FuelStations.inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == plyPed then
				FuelStations.ManageFuelUsage(vehicle)
			end
		else
			if FuelStations.fuelSynced then
				FuelStations.fuelSynced = false
			end

			if FuelStations.inBlacklisted then
				FuelStations.inBlacklisted = false
			end
		end

        Wait(wait)
	end
end)

CreateThread(function()
	while true do
		local wait = 5000

		local pumpObject, pumpDistance = FuelStations.FindNearestFuelPump()

		if pumpDistance < 2.5 then
            wait = 250

			FuelStations.isNearPump = pumpObject
			FuelStations.currentCash = tonumber(Framework.PlayerData.accounts['money'].money)
		else
			FuelStations.isNearPump = false
		end

        Wait(wait)
	end
end)

CreateThread(function()
	DecorRegister("_FUEL_LEVEL", 1)
	
	while true do
        wait = 2000

		local plyPed = PlayerPedId()

		if not FuelStations.isFueling and ((FuelStations.isNearPump and GetEntityHealth(FuelStations.isNearPump) > 0) or (GetSelectedPedWeapon(plyPed) == 883325847 and not FuelStations.isNearPump)) then
			wait = 500

            if IsPedInAnyVehicle(plyPed) and GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed), -1) == plyPed then
                wait = 1

				local pumpCoords = GetEntityCoords(FuelStations.isNearPump)

				FuelStations.DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, "~r~Veuillez descendre de votre Véhicule")
			else
                wait = 1

				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)

				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(plyPed), vehicleCoords) < 2.5 then
                    local stringCoords = GetEntityCoords(FuelStations.isNearPump)
                    local canFuel = true

                    if GetSelectedPedWeapon(plyPed) == 883325847 then
                        stringCoords = vehicleCoords

                        if GetAmmoInPedWeapon(plyPed, 883325847) < 100 then
                            canFuel = false
                        end
                    end

                    if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
                        if tonumber(FuelStations.currentCash) > 0 then
                            FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "[~b~E~s~] pour commencer a mettre de l'essence")

                            if IsControlJustReleased(0, 38) then
                                FuelStations.isFueling = true

                                FuelStations.refuelFromPump(FuelStations.isNearPump, plyPed, vehicle)
                                FuelStations.LoadAnimDict("timetable@gardener@filling_can")
                            end
                        else
                            FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "~r~Vous n'avez pas assez d'argent !")
                        end
                    elseif not canFuel then
                        FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "~r~Le Jerry-Can est vide !")
                    else
                        FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "~r~Le réservoir est plein !")
                    end
				elseif FuelStations.isNearPump then
					local stringCoords = GetEntityCoords(FuelStations.isNearPump)

					if FuelStations.currentCash >= Config['fuelStations'].JerryCanCost then
						if not HasPedGotWeapon(plyPed, 883325847) then
							FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "[~b~E~s~] pour acheter un Jerry-Can")

							if IsControlJustReleased(0, 38) then
								exports["ac"]:ExecuteServerEvent('fuel:buyCan', Config['fuelStations'].JerryCanCost)

								FuelStations.currentCash = tonumber(Framework.PlayerData.accounts['money'].money)
							end
						else
                            local refillCost = FuelStations.Round(Config['fuelStations'].RefillCost * (1 - GetAmmoInPedWeapon(plyPed, 883325847) / 4500))

                            if refillCost > 0 then
                                if FuelStations.currentCash >= refillCost then
                                    FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "[~b~E~s~] pour remplir le Jerry-Can: ~g~" .. refillCost .. "$")

                                    if IsControlJustReleased(0, 38) then
                                        exports["ac"]:ExecuteServerEvent('fuel:pay', tonumber(refillCost))

                                        SetPedAmmo(plyPed, 883325847, 4500)
                                    end
                                else
                                    FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,  "~r~Vous n'avez pas assez d'argent !")
                                end
                            else
                                FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "~r~Le Jerry-Can est plein !")
                            end
						end
					else
						FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "~r~Vous n'avez pas assez d'argent !")
					end
				end
			end
		end

		Wait(wait)
	end
end)

FuelStations.refuelFromPump = function(pumpObject, ped, vehicle)
    TaskTurnPedToFaceEntity(ped, vehicle, 1000)

	Wait(1000)

	SetCurrentPedWeapon(ped, -1569615261, true)
	FuelStations.LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)


    TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)
	while FuelStations.isFueling do
		for _, controlIndex in pairs(Config['fuelStations'].DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = ""

            extraString = "\nPrix: ~g~" .. FuelStations.Round(FuelStations.currentCost, 1) .. "$"

			FuelStations.DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "[~b~E~s~] pour arreter de remplir" .. extraString)
			FuelStations.DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, FuelStations.Round(FuelStations.currentFuel, 1) .. "%")
		else
			FuelStations.DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, "[~b~E~s~] pour arreter de remplir" .. "\nGas can: ~g~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Vehicle: " .. FuelStations.Round(FuelStations.currentFuel, 1) .. "%")
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (FuelStations.isNearPump and GetEntityHealth(pumpObject) <= 0) then
			FuelStations.isFueling = false
		end

		Wait(1)
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
    FuelStations.currentFuel = GetVehicleFuelLevel(vehicle)

	while FuelStations.isFueling do
        Wait(500)
		local oldFuel = DecorGetFloat(vehicle, "_FUEL_LEVEL")
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5 * Config['fuelStations'].CostMultiplier

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				FuelStations.currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				FuelStations.isFueling = false
			end
		else
			FuelStations.currentFuel = oldFuel + fuelToAdd
		end

		if FuelStations.currentFuel > 100.0 then
			FuelStations.currentFuel = 100.0
			FuelStations.isFueling = false
		end

		FuelStations.currentCost = FuelStations.currentCost + extraCost

		if FuelStations.currentCash >= FuelStations.currentCost then
			FuelStations.SetFuel(vehicle, FuelStations.currentFuel)
		else
			FuelStations.isFueling = false
		end
	end

	if pumpObject then
		exports["ac"]:ExecuteServerEvent('fuel:pay', FuelStations.currentCost)
	end

	FuelStations.currentCost = 0.0
end)