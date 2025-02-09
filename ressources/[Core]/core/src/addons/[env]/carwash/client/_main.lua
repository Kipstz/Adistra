
CarWash = {}

CarWash.inLavage = false;

CreateThread(function ()
	for k,v in pairs(Config['carwash'].localisations) do
		BlipManager:addBlip('carwash'..k, v, 100, 0, "Stations Lavages", 0.5, true)
		ZoneManager:createZoneWithMarker(v, 10, 4, {
			onPress = {control = 38, action = function(zone)
				local plyPed = PlayerPedId()

				if IsPedSittingInAnyVehicle(plyPed) then
					TriggerServerEvent('carwash:checkMoney')
				else
					Framework.ShowNotification("~r~Vous devez être dans un véhicule !~s~")
				end
			end}
		})
	end
end)

RegisterNetEvent('carwash:startLavage')
AddEventHandler('carwash:startLavage', function()
	local plyPed = PlayerPedId()
	local car = GetVehiclePedIsUsing(plyPed)
	local myCoords = GetEntityCoords(plyPed)

	if not CarWash.inLavage then
		CarWash.inLavage = true;

		FreezeEntityPosition(car, true)

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do Wait(100) end
		end
	
		UseParticleFxAssetNextCall("core")
		particles = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", myCoords.x, myCoords.y, myCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		
		UseParticleFxAssetNextCall("core")
		particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", myCoords.x + 2, myCoords.y, myCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		
		CreateThread(function()
			CarWash.timer = 15;
			
			while CarWash.inLavage do
				Wait(1)
	
				if CarWash.timer > 0 then
					CarWash.timer = CarWash.timer - 1
				elseif CarWash.timer == 0 then
					WashDecalsFromVehicle(car, 1.0)
					SetVehicleDirtLevel(car)
					FreezeEntityPosition(car, false)
	
					Framework.ShowNotification("Véhicule nettoyer pour ~g~"..Config['carwash'].price.."$~s~")
					CarWash.inLavage = false;
	
					StopParticleFxLooped(particles, 0)
					StopParticleFxLooped(particles2, 0)
				end
			end
		end)
	end
end)