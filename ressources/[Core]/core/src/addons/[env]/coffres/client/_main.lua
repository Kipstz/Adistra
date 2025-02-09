
Coffres = {}

Coffres.coffres = {}
Coffres.xCoffre = {}
Coffres.try = {}

Coffres.limitChar = 4;
Coffres.nbTry = 3;
Coffres.timeUnblock = 2 * 60000;
Coffres.hasCoffre = false;

RegisterNetEvent('coffres:loadChests')
AddEventHandler('coffres:loadChests', function(chests)
	if next(chests) then
		for k,v in pairs(chests) do
			table.insert(Coffres.coffres, {
				id = v.id,
				characterId = v.characterId,
				coords = v.coords
			})
			Framework.Game.SpawnLocalObject('prop_ld_int_safe_01', vector3(v.coords.x, v.coords.y, v.coords.z), function(obj)
				SetEntityHeading(obj, v.coords.h)
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj, true)
				table.insert(Coffres.xCoffre, obj)
			end)
		end
		Coffres.hasCoffre = true;
	end
end)

CreateThread(function()
	while true do 
		wait = 2000;

		local plyPed = PlayerPedId()
		local myCoords = GetEntityCoords(plyPed)
		local obj = GetHashKey('prop_ld_int_safe_01')

		if Coffres.hasCoffre then
			for k,v in pairs(Coffres.coffres) do 
				local dist = Vdist(myCoords, v.coords.x, v.coords.y, v.coords.z)

				if dist < 1.5 and obj ~= nil then 
					wait = 1;
					
					Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder au coffre")

					if IsControlPressed(0, 38) then 
						exports["ac"]:ExecuteServerEvent('3dme:shareDisplay', "* La personne tape un code *")

						if #Coffres.try >= 3 then 
							Framework.ShowNotification("~r~ Vous avez saisit trop d'essais invalide, le coffre est bloqué")

							Wait(Coffres.timeUnblock)
							table.remove(Coffres.try, 1, 2, 3)
						else
							Coffres:setCode(v.id)
						end
					end	
				end	
			end	
		end

		Wait(wait)
	end	
end)

RegisterCommand('deletecoffre', function()
	local plyPed = PlayerPedId()
	local myCoords = GetEntityCoords(plyPed)
	local obj = GetHashKey('prop_ld_int_safe_01')

	if Coffres.hasCoffre then
		for k,v in pairs(Coffres.coffres) do 
			local dist = Vdist(myCoords, v.coords.x, v.coords.y, v.coords.z)

			if dist < 2.5 and obj ~= nil then 
				TriggerServerEvent('coffres:removeChest', v.id)
				return
			end	
		end	
	end
end)

RegisterNetEvent('coffres:spawnChest')
AddEventHandler('coffres:spawnChest', function()
	Coffres:addNewChest()
end)

RegisterNetEvent('coffres:addNewChest')
AddEventHandler('coffres:addNewChest', function(chest)
    table.insert(Coffres.coffres, {
		id = chest.id,
		characterId = chest.characterId,
		coords = chest.coords
    })
    Coffres.hasCoffre = true;
end)

RegisterNetEvent('coffres:removeChest')
AddEventHandler('coffres:removeChest', function(chestId)
	for k,v in pairs(Coffres.coffres) do
		if v.id == chestId then
			table.remove(Coffres.coffres, k)
		end
	end
	Coffres:reloadChests()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k,v in pairs(Coffres.xCoffre) do
			Framework.Game.DeleteObject(v)
		end
	end
end)

RegisterNetEvent('coffres:notifCode')
AddEventHandler('coffres:notifCode', function(isValid, coffreId, data)
    if isValid then 
		Framework.ShowNotification("~g~Code correct !~s~")
		exports["ac"]:ExecuteServerEvent('3dme:shareDisplay', "* La personne a trouver le code *")

		Coffres:OpenCoffreMenu(coffreId, data)
    else  
		Framework.ShowNotification("~r~Code incorrect !~s~")
		exports["ac"]:ExecuteServerEvent('3dme:shareDisplay', "* La personne n'a pas trouver le code *")

   	    table.insert(Coffres.try, Coffres.nbTry)
   	    Coffres.nbTry = Coffres.nbTry + 1
    end	
end)
