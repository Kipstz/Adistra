
function CreateExtendedLoadout(playerId, characterId, loadout)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.loadout = loadout;

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.getLoadout(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							components[#components + 1] = component
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	function self.addWeapon(weaponName, ammo)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = Framework.GetWeaponLabel(weaponName)

			table.insert(self.loadout, {
				name = weaponName,
				label = weaponLabel,
				ammo = ammo,
				components = {},
				tintIndex = 0
			})
			
			GiveWeaponToPed(GetPlayerPed(self.source), GetHashKey(weaponName), ammo)
			SetPedAmmo(GetPlayerPed(self.source), GetHashKey(weaponName), ammo)
			self.triggerEvent('framework:addWeapon', weaponName, ammo)
		end
	end

	function self.addWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = Framework.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					self.loadout[loadoutNum].components[#self.loadout[loadoutNum].components + 1] = weaponComponent
					self.triggerEvent('framework:addWeaponComponent', weaponName, weaponComponent)
				end
			end
		end
	end

	function self.addWeaponAmmo(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('framework:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	function self.updateWeaponAmmo(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in pairs(self.loadout) do
				if v.name == weaponName then
					v.ammo = ammoCount
				end
			end
		end
	end

	function self.setWeaponTint(weaponName, weaponTintIndex)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = Framework.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex;
				self.triggerEvent('framework:setWeaponTint', weaponName, weaponTintIndex)
			end
		end
	end

	function self.getWeaponTint(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	function self.removeWeapon(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				for k2,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				RemoveWeaponFromPed(GetPlayerPed(self.source), GetHashKey(weaponName))

				self.triggerEvent('framework:removeWeapon', weaponName)
				break
			end
		end
	end

	function self.removeWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = Framework.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('framework:removeWeaponComponent', weaponName, weaponComponent)
				end
			end
		end
	end

	function self.removeWeaponAmmo(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('framework:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	function self.hasWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	function self.hasWeapon(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	function self.getWeapon(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end
	end

	return self
end

RegisterNetEvent('framework:updateWeaponAmmo')
AddEventHandler('framework:updateWeaponAmmo', function(weaponName, ammoCount)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer then
		xPlayer['loadout'].updateWeaponAmmo(weaponName, ammoCount)
		if weaponName == 'GADGET_PARACHUTE' then xPlayer['loadout'].removeWeapon(weaponName) end
	end
end)
