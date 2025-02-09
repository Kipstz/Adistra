
RegisterNetEvent('framework:restoreLoadout')
AddEventHandler('framework:restoreLoadout', function()
	Wait(6000)
	local plyPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(plyPed, true)

	for k,v in ipairs(Framework.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(plyPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(plyPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			local componentHash = Framework.GetWeaponComponent(weaponName, v2).hash
			GiveWeaponComponentToPed(PlayerPedId(), weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(plyPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end
end)

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
	if weapon ~= 'GADGET_PARACHUTE' then
		SetPedWeaponTintIndex(PlayerPedId(), GetHashKey(weapon), weaponTintIndex)
	else
		SetPedParachuteTintIndex(PlayerPedId(), weaponTintIndex)
	end
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

function StartServerSyncLoops()
	CreateThread(function()
		local currentWeapon = { Ammo = 0 }
		while Framework.PlayerLoaded do
			local sleep = 1500
			if GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261 then
				sleep = 1000
				local _, weaponHash = GetCurrentPedWeapon(PlayerPedId(), true)
				local weapon = Framework.GetWeaponFromHash(weaponHash)
				if weapon then
					local ammoCount = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
					if weapon.name ~= currentWeapon.name then
						currentWeapon.Ammo = ammoCount
						currentWeapon.name = weapon.name
					else
						if ammoCount ~= currentWeapon.Ammo then
							currentWeapon.Ammo = ammoCount
							TriggerServerEvent('framework:updateWeaponAmmo', weapon.name, ammoCount)
						end
					end
				end
			elseif (GetPedParachuteState(PlayerPedId()) == 1) or (GetPedParachuteState(PlayerPedId()) == 2) then
				TriggerServerEvent('framework:updateWeaponAmmo', 'GADGET_PARACHUTE', 0)
			end
			Wait(sleep)
		end
	end)
end