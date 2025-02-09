CreateThread(function()
	while true do
		wait = 1750

		local plyPed = PlayerPedId()
		local inVeh, inHeli = IsPedInAnyVehicle(plyPed), IsPedInAnyHeli(plyPed)

		-- VEHICLE SEAT
		if inVeh or inHeli then
			local veh = GetVehiclePedIsIn(plyPed)
			local isDriver = (GetPedInVehicleSeat(veh, -1) == plyPed)

			if not isDriver then
				wait = 100

				SetPedConfigFlag(plyPed, 184, true)
				if GetIsTaskActive(plyPed, 165) then SetPedIntoVehicle(plyPed, veh, 0) end
			end
		end

		-- DRIVE BY
		if inVeh or inHeli then
			local plyID = PlayerId()
			local veh = GetVehiclePedIsIn(plyPed)
			local isDriver = (GetPedInVehicleSeat(veh, -1) == plyPed)
			local speed = (GetEntitySpeed(veh) * 3.6)

			if tonumber(speed) > 30 then
				if isDriver then
					SetPlayerCanDoDriveBy(plyID, false)
				else
					SetPlayerCanDoDriveBy(plyID, true)
				end
			elseif tonumber(speed) < 30 then
				SetPlayerCanDoDriveBy(plyID, true)
			end
		end

		Wait(wait)
	end
end)

RegisterCommand('setPlace1', function()
	local plyPed = PlayerPedId()
	local veh = GetVehiclePedIsIn(plyPed)
	local speed = (GetEntitySpeed(veh) * 3.6)
	if IsVehicleSeatFree(veh, -1) then
		if tonumber(speed) <= 100 then 
			SetPedIntoVehicle(plyPed, veh, -1)
		else
			Framework.ShowNotification("~r~Le véhicule avance trop vite !")
		end
	else
		Framework.ShowNotification("~r~Le siège n'est pas disponible !")
	end
end)

RegisterKeyMapping('setPlace1', "Changer de place dans un véhicule (conducteur)", 'keyboard', '1')

RegisterCommand('setPlace2', function() 
	local plyPed = PlayerPedId()
	local veh = GetVehiclePedIsIn(plyPed)
	local speed = (GetEntitySpeed(veh) * 3.6)
	if IsVehicleSeatFree(veh, -1) then
		if tonumber(speed) <= 100 then 
			SetPedIntoVehicle(plyPed, veh, 0)
		else
			Framework.ShowNotification("~r~Le véhicule avance trop vite !")
		end
	else
		Framework.ShowNotification("~r~Le siège n'est pas disponible !")
	end
end)
RegisterKeyMapping('setPlace2', "Changer de place dans un véhicule (avant droit)", 'keyboard', '2')

RegisterCommand('setPlace3', function() 
	local plyPed = PlayerPedId()
	local veh = GetVehiclePedIsIn(plyPed)
	local speed = (GetEntitySpeed(veh) * 3.6)
	if IsVehicleSeatFree(veh, -1) then
		if tonumber(speed) <= 100 then 
			SetPedIntoVehicle(plyPed, veh, 1)
		else
			Framework.ShowNotification("~r~Le véhicule avance trop vite !")
		end
	else
		Framework.ShowNotification("~r~Le siège n'est pas disponible !")
	end
end)
RegisterKeyMapping('setPlace3', "Changer de place dans un véhicule (arrière gauche)", 'keyboard', '3')

RegisterCommand('setPlace4', function()
	local plyPed = PlayerPedId()
	local veh = GetVehiclePedIsIn(plyPed)
	local speed = (GetEntitySpeed(veh) * 3.6)
	if IsVehicleSeatFree(veh, -1) then
		if tonumber(speed) <= 100 then 
			SetPedIntoVehicle(plyPed, veh, 2)
		else
			Framework.ShowNotification("~r~Le véhicule avance trop vite !")
		end
	else
		Framework.ShowNotification("~r~Le siège n'est pas disponible !")
	end
end)
RegisterKeyMapping('setPlace4', "Changer de place dans un véhicule (arrière droite)", 'keyboard', '4')