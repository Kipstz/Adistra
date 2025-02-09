CreateThread(function()
	while Framework == nil do
		TriggerEvent('framework:init', function(obj) Framework = obj end)
		
        Wait(10)
	end

	Framework.PlayerData = Framework.GetPlayerData()
end)

RegisterNetEvent('framework:playerLoaded')
AddEventHandler('framework:playerLoaded', function(xPlayer)
	while Framework == nil do
		Wait(10)
	end

	Framework.PlayerData = xPlayer;

	local coords = vector3(684.2, 1018.9, 364.6)
	DestroyAllCams(true)
	camSpawn = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, -10.0, 0.0, -30.0, 80.0)
	SetCamActive(camSpawn, true)
	RenderScriptCams(true, false, 0, true, false)
end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
	while Framework == nil do
		Wait(10)
	end

	Framework.PlayerLoaded = true;

	Framework.PlayerData.characterId = xPlayer.characterId
	Framework.PlayerData.identity  = xPlayer.identity
	Framework.PlayerData.skin      = xPlayer.skin
	Framework.PlayerData.accounts  = xPlayer.accounts
	Framework.PlayerData.jobs      = xPlayer.jobs
	Framework.PlayerData.inventory = xPlayer.inventory
	Framework.PlayerData.loadout   = xPlayer.loadout
	Framework.PlayerData.position  = xPlayer.position
	Framework.PlayerData.maxWeight = xPlayer.maxWeight
	Framework.PlayerLoaded = true;
		
	DestroyAllCams(true)
	RenderScriptCams(false, false, 0, true, false)
	SetCamActive(camSpawn, false)
	DisplayRadar(true)
	FreezeEntityPosition(PlayerPedId(), false)
end)
RegisterNetEvent('framework:setGroup')
AddEventHandler('framework:setGroup', function(group, lastGroup)
	while Framework == nil do
		Wait(10)
	end
	
	Framework.PlayerData.group = group;
end)

HD_Cls.run(function()
	print("--- ^1Serveur Initialisé !^0 ---")
end)

-- ACCOUNTS --

RegisterNetEvent('framework:setAccountMoney')
AddEventHandler('framework:setAccountMoney', function(account)
	for k,v in ipairs(Framework.PlayerData.accounts) do
		if v.name == account.name then
			Framework.PlayerData.accounts[k] = account
			break
		end
	end

	Framework.PlayerData.accounts[account.name].money = account.money

	TriggerEvent('hud:update')
end)

-- JOBS --


Citizen.CreateThread(function()

    -- Framework - do not touch
    while Framework == nil do
        TriggerEvent('framework:init', function(obj) Framework = obj end)
        Citizen.Wait(10)
    end

    while true do
        Citizen.Wait(500)
        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'police' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(1)
        elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'ambulance' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(2)
        elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'sheriff' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(3)
			exports["rp-radio"]:GivePlayerAccessToFrequencies(1)
        elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'sheriffpaleto' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(4)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'gouvernement' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(5)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'usarmy' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(6)
--Communes
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'police' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(8)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'police' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(9)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'sheriff' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(9)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'sheriffpaleto' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(9)
--Fib
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(1)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(2)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(3)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(4)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(5)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(6)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(7)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(8)
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
            exports["rp-radio"]:GivePlayerAccessToFrequencies(9)
        else
            exports["rp-radio"]:RemovePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6, 7, 8, 9)
        end
    end

    GenerateFrequencyList()

end)

RegisterNetEvent('framework:setJob')
AddEventHandler('framework:setJob', function(job)
	Framework.PlayerData.jobs['job'] = job

	TriggerEvent('hud:update')
end)

RegisterNetEvent('framework:setJob2')
AddEventHandler('framework:setJob2', function(job2)
	Framework.PlayerData.jobs['job2'] = job2

	TriggerEvent('hud:update')
end)

-- INVENTORY --

RegisterNetEvent('framework:addInventoryItem')
AddEventHandler('framework:addInventoryItem', function(item, count)
	for k,v in ipairs(Framework.PlayerData.inventory) do
		if v.name == item then
			-- Framework.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			Framework.PlayerData.inventory[k].count = count
			break
		end
	end
end)

RegisterNetEvent('framework:removeInventoryItem')
AddEventHandler('framework:removeInventoryItem', function(item, count)
	for k,v in ipairs(Framework.PlayerData.inventory) do
		if v.name == item then
			-- Framework.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			Framework.PlayerData.inventory[k].count = count
			break
		end
	end
end)

RegisterNetEvent('framework:setMaxWeight')
AddEventHandler('framework:setMaxWeight', function(newMaxWeight) Framework.PlayerData.maxWeight = newMaxWeight end)

-- LOADOUT --

RegisterNetEvent('framework:addWeapon')
AddEventHandler('framework:addWeapon', function(weaponName, weaponAmmo)
	local found = false

	for k,v in pairs(Framework.PlayerData.loadout) do
		if v.name == weaponName then
			found = true
			break
		end
	end

	if not found then
		local weaponLabel = Framework.GetWeaponLabel(weaponName)
		-- Framework.UI.ShowInventoryItemNotification(true, weaponLabel, false)

		table.insert(Framework.PlayerData.loadout, {
			name = weaponName,
			ammo = weaponAmmo,
			label = weaponLabel,
			components = {}
		})
	end
end)

RegisterNetEvent('framework:addWeaponComponent')
AddEventHandler('framework:addWeaponComponent', function(weaponName, weaponComponent)
	for k,v in pairs(Framework.PlayerData.loadout) do
		if v.name == weaponName then
			local component = Framework.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				local found = false

				for k2, v2 in pairs(v.components) do
					if v2 == weaponComponent then
						found = true
						break
					end
				end

				if not found then
					local plyPed = PlayerPedId()
					local weaponHash = GetHashKey(weaponName)

					-- Framework.UI.ShowInventoryItemNotification(true, component.label, false)
					table.insert(v.components, weaponComponent)
					GiveWeaponComponentToPed(plyPed, weaponHash, component.hash)
				end
			end
		end
	end
end)

RegisterNetEvent('framework:setWeaponAmmo')
AddEventHandler('framework:setWeaponAmmo', function(weaponName, weaponAmmo)
	for k,v in pairs(Framework.PlayerData.loadout) do
		if v.name == weaponName then
			local plyPed = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)

			v.ammo = weaponAmmo
			SetPedAmmo(plyPed, weaponHash, weaponAmmo)
			break
		end
	end
end)

RegisterNetEvent('framework:setWeaponTint')
AddEventHandler('framework:setWeaponTint', function(weapon, weaponTintIndex)
	SetPedWeaponTintIndex(PlayerPedId(), GetHashKey(weapon), weaponTintIndex)
end)

RegisterNetEvent('framework:removeWeapon')
AddEventHandler('framework:removeWeapon', function(weaponName)
	for k,v in pairs(Framework.PlayerData.loadout) do
		if v.name == weaponName then
			local plyPed = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)
			local weaponLabel = Framework.GetWeaponLabel(weaponName)

			-- Framework.UI.ShowInventoryItemNotification(false, weaponLabel, false)
			table.remove(Framework.PlayerData.loadout, k)
			break
		end
	end
end)

RegisterNetEvent('framework:removeWeaponComponent')
AddEventHandler('framework:removeWeaponComponent', function(weaponName, weaponComponent)
	for k,v in pairs(Framework.PlayerData.loadout) do
		if v.name == weaponName then
			local component = Framework.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				for k2, v2 in pairs(v.components) do
					if v2 == weaponComponent then
						local plyPed = PlayerPedId()
						local weaponHash = GetHashKey(weaponName)

						-- Framework.UI.ShowInventoryItemNotification(false, component.label, false)
						table.insert(v.components, v2)
						RemoveWeaponComponentFromPed(plyPed, weaponHash, component.hash)
						break
					end
				end
			end
		end
	end
end)

RegisterKeyMapping("openmenujob", 'Ouvrir menu job', "keyboard", 'F6')

RegisterCommand("openmenujob", function(source, args, rawCommand)
	if not IsPlayerDead(PlayerId()) then
		if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'gouvernement' then
			GouvernementJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'usarmy' then
			UsArmyJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'ambulance' then
			AmbulanceJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'cayoems' then
			CayoEmsJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'police' then 
			PoliceJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'sheriff' then
			SheriffJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'sheriffpaleto' then
			SheriffPaletoJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'swat' then
			SwatJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'fib' then
			FibJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'agentimmo' then
			Agent_ImmoJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'mecano' then
			MecanoJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'burger' then
			BurgerShotJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'space' then
			SpaceJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'cookies' then
			CookiesJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'bennys' then
			BennysJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'cayoauto' then
			CayoAutoJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'journalist' then
			JournalisteJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'taxi' then
			TaxiJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'vigneron' then
			VigneronJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'unicorn' then
			UnicornJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == '77club' then
			NightClub.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'hookah' then
			HookahJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'tequilala' then
			TequilalaJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'yellowjack' then
			YellowJackJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'pericobar' then
			PericoBarJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'bahama' then
			BahamaJob.OpenF6Menu()
		elseif Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == 'paletogarage' then
			PaletoGarageJob.OpenF6Menu()
		end
	else
		Framework.ShowNotification("~r~Vous ne pouvez pas ouvrir ce menu en étant mort !~s~")
	end
end, false)