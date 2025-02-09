
local bomba, rob_status = false, true
local timer = GetGameTimer()
local prev_timer = 0
local stand = {}

CreateThread(function()	
	-- BLIP
	blip = AddBlipForCoord(-624.963, -232.908, 38.057)
	SetBlipSprite(blip, 439)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 5)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config['rob_vangelico'].Lang['blip'])
	EndTextCommandSetBlipName(blip)
end)

CreateThread(function ()
	while true do
		local w = 2000
		local d = #(GetEntityCoords(PlayerPedId()) - vector3(Config['rob_vangelico'].AirVent[1],Config['rob_vangelico'].AirVent[2],Config['rob_vangelico'].AirVent[3]))

		if d <= Config['rob_vangelico'].AirVentDist and not bomba then
			w = 5
			if d > 1 and d <= Config['rob_vangelico'].AirVentDist then
				Framework.ShowHelpNotification(Config['rob_vangelico'].Lang['air_vent'])
			elseif d <= 1 then
				Framework.ShowHelpNotification(Config['rob_vangelico'].Lang['plant_gas'])
			end

			if IsControlJustPressed(0,38) and d < 1 then
				Framework.TriggerServerCallback('rob_vangelico:cooldown',function(cooldown)
					if cooldown == 'not_cops' then
						Framework.ShowNotification(Config['rob_vangelico'].Lang['not_cops'])
					elseif not cooldown then
						Framework.ShowNotification(Config['rob_vangelico'].Lang['cooldown'])
					elseif cooldown then
						bomba = true
						TriggerEvent('rob_vangelico:bomba')
						TriggerServerEvent("rob_vangelico:timer")
					end
				end)
			end
		end

		Wait(w)
	end
end)

CreateThread(function ()
	while true do	
		local w = 500
		local p = PlayerPedId()
		local c = GetEntityCoords(p)
		local b = false
		
		if not rob_status then
			
			-- temp work around for only being able to do vangelico robbery once otherwise u need to restart the script... but im moving this server side in the future
			--  so this will be irrelevant when i do... but its a temp fix for now
			if timer == prev_timer then
				prev_timer = timer
				timer = GetGameTimer()
				
			end

			w = 5
			for i = 1, #stand do
				local s = stand[i]
				if GetDistanceBetweenCoords(c, s.x, s.y, s.z, true) < 1 and not s.broken then 				
					Framework.ShowHelpNotification(Config['rob_vangelico'].Lang['break'])
					if GetDistanceBetweenCoords(c, s.x, s.y, s.z, true) < 1 then
						if IsControlJustPressed(0, 38) then				
							if Config['rob_vangelico'].WeaponsWL then
								local wp = GetSelectedPedWeapon(p)
								b = true
								if b then
									s.broken = true 
									-- update the server and tell it that this cabnet has been smashed
									TriggerServerEvent("rob_vangelico:smash_counter",s.x,s.y,s.z,s.broken)
									--- i probs should add a server client trigger for this so its synced with other players but eh works for now
									PlaySoundFromCoord(-1, "Glass_Smash", s.x, s.y, s.z, "", 0, 0, 0)

									-- request the animation dictionary
									if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
									RequestNamedPtfxAsset("scr_jewelheist")
									end
									-- wait till dictionary is loaded and before we continue otherwise we will have issues with anims not playing
									while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
									Wait(1)
									end
									SetPtfxAssetNextCall("scr_jewelheist")
									StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", s.x, s.y, s.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
									anim("missheist_jewel") 
									-- added a calc to calculate peds actual z location 
									calc_z = s.z-1.46
									-- set the ped to head towards the stand before playing animation
									SetEntityCoords(p, s.ax,s.ay,calc_z)
    								SetEntityHeading(p, s.h)
									-- set animation and lock it to x y and z with 8 second blend in and 3 second blend out
									TaskPlayAnim(p, "missheist_jewel", "smash_case", 8.0, 3.0, -1, 2, 0, 0, 0, 0 ) 
									-- wait for the animation to finish
									Wait(6000)
									-- clear the animation task if its not fully finished
									ClearPedTasksImmediately(p)
									-- trigger server event to give items
									exports["ac"]:ExecuteServerEvent('rob_vangelico:stand')
								else
									-- if user doesnt have weapon then give them this error (only if stated in Config['rob_vangelico'] to use weapon)
									Framework.ShowNotification(Config['rob_vangelico'].Lang['needs_weapon'])									
								end
							else
								s.broken = true 
								PlaySoundFromCoord(-1, "Glass_Smash", s.x, s.y, s.z, "", 0, 0, 0)
								if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
									RequestNamedPtfxAsset("scr_jewelheist")
								end
								while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
									Wait(1)
								end
								SetPtfxAssetNextCall("scr_jewelheist")
								StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", s.x, s.y, s.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
								anim("missheist_jewel") 
								TaskPlayAnim(p, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
								Wait(5000)
								ClearPedTasksImmediately(p)
								exports["ac"]:ExecuteServerEvent('rob_vangelico:stand')
							end
						end
					end
				end
			end
			
			
			-- probs should move this server side, will update in the future
			if GetGameTimer() - timer > Config['rob_vangelico'].RobTime*1000*60 then
				
				rob_status = true
				bomba = false
				-- temp fix to be able to do robbery after doing it once, set prev timer to current timer so we know to create a new timer next time the thread is run
				prev_timer = timer
				-- tell server the robbery is done
				TriggerServerEvent("rob_vangelico:timer",rob_status,bomba)
			end
		else
			w = 1000
		end
		Wait(w)
	end
end)

RegisterNetEvent('rob_vangelico:change_timer_status')
AddEventHandler('rob_vangelico:change_timer_status', function(rob_status_server,bomba_server)
	rob_status = rob_status_server
	bomba = bomba_server
end)

RegisterNetEvent('rob_vangelico:breakable_units')
AddEventHandler('rob_vangelico:breakable_units', function(stand_server)
	stand = stand_server
end)

RegisterNetEvent('rob_vangelico:statusUpdate')
AddEventHandler('rob_vangelico:statusUpdate', function(status)
	rob_status = status
end)

RegisterNetEvent('rob_vangelico:bomba')
AddEventHandler('rob_vangelico:bomba', function()
	local p = PlayerPedId()

	Framework.Streaming.RequestAnimDict('anim@heists@ornate_bank@thermal_charge', function(dict)
		if HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge') then

			SetEntityCoords(p, -635.89,-213.86,52.55)
    		SetEntityHeading(p, 32.45)
			
            local fwd, _, _, pos = GetEntityMatrix(p)
            local np = (fwd * 0.8) + pos            
            SetEntityCoords(p, np.xy, np.z - 1)
            local rot, pos = GetEntityRotation(p), GetEntityCoords(p)
            SetPedComponentVariation(p, 5, -1, 0, 0)
            local b = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), pos.x, pos.y, pos.z,  true,  true, false)
            local sc = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, 0, 0, 1065353216, 0, 1.3)
            SetEntityCollision(b, 0, 1)
            NetworkAddPedToSynchronisedScene(p, sc, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(b, sc, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
            NetworkStartSynchronisedScene(sc)
            Wait(1500)
            pos = GetEntityCoords(p)
            prop = CreateObject(GetHashKey("hei_prop_heist_thermite"), pos.x, pos.y, pos.z + 0.2, 1, 1, 1)
            SetEntityCollision(prop, 0, 1)
            AttachEntityToEntity(prop, p, GetPedBoneIndex(p, 28422), 0, 0, 0, 0, 0, 180.0, 1, 1, 0, 1, 1, 1)
            Wait(4000)
            Framework.Game.DeleteObject(b)
            SetPedComponentVariation(p, 5, 113, 0, 0)
            DetachEntity(prop, 1, 1)
            FreezeEntityPosition(prop, 1)
            SetEntityCollision(prop, 0, 1)
            pCoords = GetEntityCoords(prop)
            TriggerServerEvent('rob_vangelico:effect', prop)
			Wait(4000)
			NetworkStopSynchronisedScene(sc)
			DeleteObject(prop)
			rob_status = false
			Framework.ShowNotification(Config['rob_vangelico'].Lang['started'])
			TriggerServerEvent('rob_vangelico:gas')
        end
    end)
end)

RegisterNetEvent('rob_vangelico:bombaFx')
AddEventHandler('rob_vangelico:bombaFx', function(entity)
	Framework.Streaming.RequestNamedPtfxAsset('scr_ornate_heist', function()
		if HasNamedPtfxAssetLoaded('scr_ornate_heist') then
			SetPtfxAssetNextCall("scr_ornate_heist")
            explosiveEffect = StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_burn", entity, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0, 0, 0)
			Wait(4000)
			StopParticleFxLooped(explosiveEffect, 0)
		end
    end)
end)

RegisterNetEvent('rob_vangelico:smoke')
AddEventHandler('rob_vangelico:smoke', function()
	if #(GetEntityCoords(PlayerPedId()) - vector3(-632.39, -238.26, 38.07)) < 300 then
		local counter = 0
		local particleEffects = {}
		RequestNamedPtfxAsset('core')
		while not HasNamedPtfxAssetLoaded('core') do
			Wait(1)
		end
		while true do 
			counter = counter + 1			
			if counter <= Config['rob_vangelico'].GasTime * 4 then
				--[[
					original orange looking particle effect if you want to use just replace exp_grd_grenade_smoke with veh_respray_smoke 
				StartParticleFxLoopedAtCoord("veh_respray_smoke", -621.85, -230.71, 38.05, 0.0, 0.0, 0.0, 10.0, false, false, false, 0)	

			
				i use multiple particles to give more smoke coverage without it going out the doors, you can remove all if you want and only have one
				i also replaced the default orange one with a more white smoke

			]]

			-- tell to request dictionary for next partical spawn
			UseParticleFxAssetNextCall('core')
			-- store the particle being created and insert it into a table for removal later
			local particle = StartParticleFxLoopedAtCoord("exp_grd_grenade_smoke", -621.85, -230.71, 37.05, 0.0, 0.0, 0.0, 2.0, false, false, false, 0)
			table.insert(particleEffects, 1, particle)
			Wait(1000)
			
			-- this is repeat code didnt seem the point in running a loop 4 times but feel free to change to a loop if you want
			UseParticleFxAssetNextCall('core')
			local particle = StartParticleFxLoopedAtCoord("exp_grd_grenade_smoke", -624.45, -227.78, 37.05, 0.0, 0.0, 0.0, 2.0, false, false, false, 0)
			table.insert(particleEffects, 1, particle)
			Wait(1000)
			
			
			Wait(4000)
			else
				-- loop through the table or particles and stop the effect
				for _,particle in pairs(particleEffects) do
                    -- Stopping each particle effect.
                    StopParticleFxLooped(particle, true)
                end
				
				break
			end
		end
	end
end)

RegisterNetEvent('rob_vangelico:notify')
AddEventHandler('rob_vangelico:notify', function()
	while Framework.PlayerData.jobs == nil do
        Wait(1)
    end
	
	for k,v in pairs(Config['rob_vangelico'].PoliceJobName) do
		if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v then
			Framework.ShowNotification(Config['rob_vangelico'].Lang['police'])
			blipRobbery = AddBlipForCoord(-632.39, -238.26, 38.07)
			SetBlipSprite(blipRobbery, 161)
			SetBlipScale(blipRobbery, 2.0)
			SetBlipColour(blipRobbery, 3)
			PulseBlip(blipRobbery)
			Wait(60000)
			RemoveBlip(blipRobbery)
		end
	end
end)

function anim(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function hasWeapon(weapon)	
	for i = 1, #Config['rob_vangelico'].Weapons do
		if weapon == Config['rob_vangelico'].Weapons[i] then
			return true
		end
	end
	return false
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end