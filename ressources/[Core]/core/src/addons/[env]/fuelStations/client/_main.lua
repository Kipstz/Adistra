FuelStations = {}

function FuelStations.DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

function FuelStations.GetFuel(vehicle)
	return DecorGetFloat(vehicle, "_FUEL_LEVEL")
end

function FuelStations.SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
	end
end

function FuelStations.LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
end

function FuelStations.Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

function FuelStations.CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Stations Essences")
	EndTextCommandSetBlipName(blip)

	return blip
end

function FuelStations.FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config['fuelStations'].Models[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end

function FuelStations.ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, "_FUEL_LEVEL") then
		FuelStations.SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		FuelStations.SetFuel(vehicle, FuelStations.GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		FuelStations.SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config['fuelStations'].Usage[FuelStations.Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config['fuelStations'].Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

function FuelStations.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

RegisterCommand('getClosestPropHash', function()
    local playerPed = PlayerPedId()  -- Récupère l'ID du joueur
    local playerCoords = GetEntityCoords(playerPed)  -- Récupère les coordonnées du joueur

    local closestProp = nil
    local closestDistance = 10.0  -- Distance maximale à vérifier (en mètres)

    -- Boucle sur tous les objets dans la scène
    for _, object in pairs(GetGamePool('CObject')) do
        local objectCoords = GetEntityCoords(object)
        local distance = #(playerCoords - objectCoords)

        if distance < closestDistance then
            closestDistance = distance
            closestProp = object
        end
    end

    if closestProp then
        local propHash = GetEntityModel(closestProp)  -- Récupère le hash du prop
        print("Le hash du prop le plus proche est: " .. tostring(propHash))
    else
        print("Aucun prop trouvé à proximité.")
    end
end, false)
  
function FuelStations.drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
  
function FuelStations.drawRct(x,y,width,height,r,g,b,a)
    DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

CreateThread(function()
	for k,v in pairs(Config['fuelStations'].Zones) do
		FuelStations.CreateBlip(v)
	end
end)