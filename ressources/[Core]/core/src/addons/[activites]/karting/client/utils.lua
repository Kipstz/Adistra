function ForceDeleteEntity(entity)
	if DoesEntityExist(entity) then
		NetworkRequestControlOfEntity(entity)
		local gameTime = GetGameTimer()

		while DoesEntityExist(entity) and (not NetworkHasControlOfEntity(entity) or ((GetGameTimer() - gameTime) < 1000)) do
			Citizen.Wait(10)
		end

		if DoesEntityExist(entity) then
			DetachEntity(entity, false, false)
			SetEntityAsMissionEntity(entity, false, false)
			SetEntityCollision(entity, false, false)
			SetEntityAlpha(entity, 0, true)
			SetEntityAsNoLongerNeeded(entity)

			if IsAnEntity(entity) then
				DeleteEntity(entity)
			elseif IsEntityAPed(entity) then
				DeletePed(entity)
			elseif IsEntityAVehicle(entity) then
				DeleteVehicle(entity)
			elseif IsEntityAnObject(entity) then
				DeleteObject(entity)
			end

			gameTime = GetGameTimer()

			while DoesEntityExist(entity) and ((GetGameTimer() - gameTime) < 2000) do
				Citizen.Wait(10)
			end

			if DoesEntityExist(entity) then
				SetEntityCoords(entity, vector3(10000.0, -1000.0, 10000.0), vector3(0.0, 0.0, 0.0), false)
			end
		end
	end
end

CreateThread(function()
    while true do
        local interval = 15 * 1000

        for k,v in pairs(kartingManagement.myVehicles) do
            if #(GetEntityCoords(v.entity) - v.spawnedCoords) > 500.0 then
                DeleteEntity(v.entity)
				Framework.ShowNotification("~r~Vous avez quitté la zone du karting, Votre véhicule à été saisie !")
                kartingManagement.myVehicles[k] = nil
                kartingManagement.isInActivity = false
            end

            if GetGameTimer() > v.deleteTime then
                DeleteEntity(v.entity)
				Framework.ShowNotification("~r~Vous avez dépassé le quota (minutes), Votre véhicule à été saisie !")
                kartingManagement.myVehicles[k] = nil
                kartingManagement.isInActivity = false
            end
        end

        Wait(interval)
    end
end)
