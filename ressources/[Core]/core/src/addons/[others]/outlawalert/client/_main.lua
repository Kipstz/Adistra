
OutlawAlert = {}

CreateThread( function()
    while true do
        wait = 2000;

		local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed)
		local sex = nil;
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)

		if Config['outlawalert'].gunshotAlert then
			if IsPedArmed(plyPed, 4) then
				wait = 250;
				if IsPedShooting(plyPed) then
					Framework.TriggerServerCallback('gunfight:isInZone', function(isInZone)
						if not isInZone then
							if s2 == 0 then
								TriggerServerEvent('outlawalert:alert', 'gunshot', vector3(plyPos.x, plyPos.y, plyPos.z), sex, street1)
							elseif s2 ~= 0 then
								TriggerServerEvent('outlawalert:alert', 'gunshot', vector3(plyPos.x, plyPos.y, plyPos.z), sex, street1, street2)
							end
						end
					end)
					Wait(3000)
				end
			end
		end

		-- if Config['outlawalert'].meleeAlert then
		-- 	if IsPedOnFoot(plyPed) then
		-- 		wait = 50;
		-- 		if IsPedInMeleeCombat(plyPed) then
		-- 			TriggerServerEvent('outlawalert:meleeInProgressPos', vector3(plyPos.x, plyPos.y, plyPos.z))
		-- 			if s2 == 0 then
		-- 				TriggerServerEvent('outlawalert:meleeInProgressS1', sex, street1)
		-- 			elseif s2 ~= 0 then
		-- 				TriggerServerEvent("outlawalert:meleeInProgress", sex, street1, street2)
		-- 			end
		-- 			Wait(3000)
		-- 		end
		-- 	end
		-- end

		Wait(wait)
    end
end)


-- CreateThread( function()
--     while true do
--         wait = 2000

-- 		local plyPed = PlayerPedId()
--         local plyPos = GetEntityCoords(plyPed)
--         local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
--         local street1 = GetStreetNameFromHashKey(s1)
--         local street2 = GetStreetNameFromHashKey(s2)

--         if IsPedTryingToEnterALockedVehicle(plyPed) or IsPedJacking(plyPed) then
-- 			Wait(3000)

-- 			local vehicle = GetVehiclePedIsIn(plyPed,false)
-- 			local vehicleProps  = Framework.Game.GetVehicleProperties(vehicle)

-- 			--if Framework ~= nil and Framework.PlayerData.jobs ~= nil and Framework.PlayerData.jobs['job'].name ~= 'police' then
-- 				Framework.TriggerServerCallback('outlawalert:ownvehicle',function(valid)
-- 					if (valid) then
-- 					else
-- 						TriggerServerEvent('outlawalert:thiefInProgressPos', vector3(plyPos.x, plyPos.y, plyPos.z))
						
-- 						local veh = GetVehiclePedIsTryingToEnter(plyPed)
-- 						local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
-- 						local vehName2 = GetLabelText(vehName)
						
-- 						if s2 == 0 then
-- 							TriggerServerEvent('outlawalert:thiefInProgressS1', street1, vehName2, sex)
-- 						elseif s2 ~= 0 then
-- 							TriggerServerEvent('outlawalert:thiefInProgress', street1, street2, vehName2, sex)
-- 						end
-- 					end
-- 				end, vehicleProps)
-- 			--end
--         end

-- 		Wait(wait)
--     end
-- end)