
Property = {}

Property.inTimeout = false;
Property.load = false;
Property.properties = {}
Property.owneds = {}
SharedProperty = {}

Property.inPropertyId = 0;

Property.typesOpen = {
	types = {
		['enter'] = {action = function(id) Property:openEnterMenu2(id) end},
		['exit'] = {action = function(id) Property:openExitMenu2(id) end},
		['coffre'] = {action = function(id, coords) Property:openCoffreMenu(id, coords) end},
		['dressing'] = { action = function(id) Property:openDressingMenu(id) end},
		['garage'] = { action = function(id) Property:openGarageMenu(id) end}
	}
}

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function()
	Wait(500)
	Framework.TriggerServerCallback("property:getProperties", function(properties, owneds)
		Property.load = true;
		for k,v in pairs(properties) do
			Property.properties[v.id] = {
				id = v.id,
				params = v.params,
				points = v.points,
				owned = v.owned,
				owners = v.owners
			}
		end
	
		if next(owneds) then
			for k,v in pairs(owneds) do
				for k2,v2 in pairs(v.owners) do
					if v2 == Framework.PlayerData.characterId then
						Property.owneds[v.id] = {
							id = v.id,
							params = v.params,
							points = v.points,
							owners = v.owners
						}
					end
				end
				SharedProperty[v.id] = {}
				SharedProperty[v.id].id = v.id;
				SharedProperty[v.id].name = v.params.name;
				SharedProperty[v.id].data = v.data;
			end
		end
		Wait(2500)
		Framework.TriggerServerCallback("property:getLastProperty", function(id)
			if id and id ~= '' then
				TriggerEvent('instance:create', 'property', {property = id, instanceId = id})
			end
		end)
	end)
end)

RegisterNetEvent('property:updateOwner')
AddEventHandler('property:updateOwner', function(idProperty)
	Framework.TriggerServerCallback('property:getProperty', function(properties, owneds)
		Property.load = true;
		Property.properties[idProperty] = {
			id = properties.id,
			params = properties.params,
			points = properties.points,
			owned = properties.owned,
			owners = properties.owners
		}

		if not next(owneds) then
			Property.owneds[idProperty] = nil;
		else
			for k2,v2 in pairs(owneds.owners) do
				if v2 == Framework.PlayerData.characterId then
					Property.owneds[idProperty] = {
						id = owneds.id,
						params = owneds.params,
						points = owneds.points,
						owners = owneds.owners
					}
				end
			end
			SharedProperty[owneds.id] = {}
			SharedProperty[owneds.id].id = owneds.id;
			SharedProperty[owneds.id].data = owneds.data;
		end	
		Property:CreateBlips()
	end, idProperty)
end)

RegisterNetEvent('property:addProperty')
AddEventHandler('property:addProperty', function(property)
	Property.properties[property.id] = {
		id = property.id,
		params = property.params,
		points = property.points,
		owned = false
	}
	Property:CreateBlips()
end)

RegisterNetEvent('property:removeProperty')
AddEventHandler('property:removeProperty', function(propertyId)
	Property.properties[propertyId] = nil;
	Property:CreateBlips()
end)

CreateThread(function()
	while not Property.load do Wait(1000) end
	Property:CreateBlips()

	while true do
		wait = 2500;

		local plyPed = PlayerPedId()
		local myCoords = GetEntityCoords(plyPed)

		for k,v in pairs(Property.properties) do
			if not v.disabled then
				if not v.owned and v.points ~= nil and v.points.enter ~= nil and v.points.enter.x ~= nil then
					-- ENTER --
					local dist = Vdist(myCoords, v.points.enter.x, v.points.enter.y, v.points.enter.z)

					if dist < 15.0 and dist > 1.5 then
						wait = 5;

						DrawMarker(27, v.points.enter.x, v.points.enter.y, v.points.enter.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
					elseif dist < 1.5 then
						wait = 1;
	
						Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour acceder à l'~o~Entrée")
			
						if IsControlJustPressed(0, 51) then
							Property:openEnterMenu(v.id)
						end
					end
					-- EXIT --
					if tonumber(Property.inPropertyId) == tonumber(v.id) then
						local dist2 = Vdist(myCoords, v.points.exit.x, v.points.exit.y, v.points.exit.z)

						if dist2 < 15.0 and dist2 > 1.5 then
							wait = 5;
	
							DrawMarker(27, v.points.exit.x, v.points.exit.y, v.points.exit.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
						elseif dist2 < 1.5 then
							wait = 1;
		
							Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour acceder à la Sortie")
				
							if IsControlJustPressed(0, 51) then
								Property:openExitMenu(v.id)
							end
						end
					end
				elseif v.owned and v.points ~= nil and v.points.enter ~= nil and v.points.enter.x ~= nil then
					local can = true;
					for k2,v2 in pairs(v.owners) do
						if v2 == Framework.PlayerData.characterId then
							can = false;
						end
					end

					if can then
						-- ENTER --
						local dist = Vdist(myCoords, v.points.enter.x, v.points.enter.y, v.points.enter.z)

						if dist < 15.0 and dist > 1.5 then
							wait = 5;
						
							DrawMarker(27, v.points.enter.x, v.points.enter.y, v.points.enter.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
						elseif dist < 1.5 then
							wait = 1;
						
							Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour acceder à l'~o~Entrée")
						
							if IsControlJustPressed(0, 51) then
								Property:openEnterMenu(v.id)
							end
						end
						-- EXIT --
						if tonumber(Property.inPropertyId) == tonumber(v.id) then
							local dist2 = Vdist(myCoords, v.points.exit.x, v.points.exit.y, v.points.exit.z)
						
							if dist2 < 15.0 and dist2 > 1.5 then
								wait = 5;
						
								DrawMarker(27, v.points.exit.x, v.points.exit.y, v.points.exit.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
							elseif dist2 < 1.5 then
								wait = 1;
						
								Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour acceder à la Sortie")
						
								if IsControlJustPressed(0, 51) then
									Property:openExitMenu(v.id)
								end
							end
						end
					end
				end
			end
		end

		if next(Property.owneds) then
			for k,v in pairs(Property.owneds) do
				if not v.disabled and v.points ~= nil then
					for k2, v2 in pairs(v.owners) do
						if v2 == Framework.PlayerData.characterId then
							for k3, v3 in pairs(v.points) do
								if v.params.garage and k3 == 'vehSpawn' then
									if IsPedInAnyVehicle(plyPed) then
										local dist = Vdist(myCoords, v3.x, v3.y, v3.z)
			
										if dist < 15.0 and dist > 1.5 then
											wait = 5;
								
											DrawMarker(27, v3.x, v3.y, v3.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
										elseif dist < 1.5 and not Property.inTimeout then
											wait = 1;
						
											Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour déposer le véhicule")
			
											if IsControlJustPressed(0, 51) then
												local vehicle = GetVehiclePedIsUsing(plyPed)
												local props = Framework.Game.GetVehicleProperties(vehicle)
												local isOwned = false;

												Framework.TriggerServerCallback('garages:getOwneds', function(myCars) 
													for k,v in pairs(myCars) do
														if v.plate == props.plate then
															isOwned = true;
														end
													end
												end, 'car')
											
												Wait(500)
											
												if isOwned then	
													data = {
														label = GetDisplayNameFromVehicleModel(props.model),
														props = props
													}
													
													TriggerServerEvent("property:depositVeh", v.id, data)
			
													Framework.Game.DeleteVehicle(vehicle)
												else
													Framework.ShowNotification("~r~Ce n'est pas votre véhicule !")
												end

												Property.inTimeout = true;

												SetTimeout(2000, function()
													Property.inTimeout = false;
												end)
											end
										end
									end
								elseif (k3 == 'enter') or (k3 == 'garage') then
									local dist = Vdist(myCoords, v3.x, v3.y, v3.z)
			
									if dist < 15.0 and dist > 1.5 then
										wait = 5;
							
										DrawMarker(27, v3.x, v3.y, v3.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
									elseif dist < 1.5 then
										wait = 1;
					
										Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour intéragir")
							
										if IsControlJustPressed(0, 51) then
											Property:open(k3, v.id)
										end
									end
								elseif (k3 ~= 'enter' and k3 ~= 'vehSpawn' and k3 ~= 'vehHeading') then
									if tonumber(Property.inPropertyId) == tonumber(v.id) then
										local dist = Vdist(myCoords, v3.x, v3.y, v3.z)
			
										if dist < 15.0 and dist > 1.5 then
											wait = 5;
								
											DrawMarker(27, v3.x, v3.y, v3.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, true, 2, true)
										elseif dist < 1.5 then
											wait = 1;
						
											Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour intéragir")
								
											if IsControlJustPressed(0, 51) then
												Property:open(k3, v.id, vector3(v3.x, v3.y, v3.z))
											end
										end
									end
								end
							end
						end
					end
				end
				
			end
		end
		Wait(wait)
	end
end)