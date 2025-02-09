AutoEcole = {}

AutoEcole.Licenses = {}

CreateThread(function()
	while Framework == nil do
		TriggerEvent('framework:init', function(obj) Framework = obj end)
		
		Wait(0)
	end
end)

CreateThread(function()
    for k,v in pairs(AutoEcole_Config.Zones) do
		if k == 'DMVSchool' then
			local blip = AddBlipForCoord(v.pos)

			SetBlipSprite(blip, 269)
			SetBlipColour(blip, 4)
			SetBlipScale(blip, 0.8)
			SetBlipAsShortRange(blip, true)
	
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName("Auto-École")
			EndTextCommandSetBlipName(blip)
		end
    end

    while true do
        wait = 2300

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        for k,v in pairs(AutoEcole_Config.Zones) do
			if k == 'DMVSchool' then
				local dist = Vdist(myCoords, v.pos)

				if dist < 15 and dist > 1.5 then
					wait = 1 
	
					DrawMarker(27, v.pos.x, v.pos.y, v.pos.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
				elseif dist < 1.5 then
					wait = 1
	
					Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour accéder à l'auto-école")
	
					if IsControlJustPressed(0, 38) then
						AutoEcole.OpenMenu()
					end
				end
			end
        end

        Wait(wait)
    end
end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
	Framework.PlayerData = xPlayer
end)

RegisterNetEvent('framework:setAccountMoney')
AddEventHandler('framework:setAccountMoney', function(account)
	for i = 1, #Framework.PlayerData.accounts, 1 do
		if Framework.PlayerData.accounts[i].name == account.name then
			if account.name == 'money' then
				Framework.PlayerData.money = account.money
			end
			
			Framework.PlayerData.accounts[i] = account
			break
		end
	end
end)

RegisterNetEvent('AutoEcole:loadLicenses')
AddEventHandler('AutoEcole:loadLicenses', function(licenses)
	AutoEcole.Licenses = licenses
end)

local CurrentTest = nil
local CurrentTestType = nil
local CurrentVehicle = nil
local CurrentCheckPoint = 0
local LastCheckPoint = -1
local CurrentBlip = nil
local CurrentZoneType = nil
local DriveErrors = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

    SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)

	exports["ac"]:ExecuteServerEvent('AutoEcole:pay', AutoEcole_Config.Prices['dmv'])
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		exports["ac"]:ExecuteServerEvent('AutoEcole:addLicense', 'dmv')
		Framework.ShowNotification("Vous avez ~g~réussi~s~ le test !")
	else
		Framework.ShowNotification("Vous avez ~r~échouer~s~ le test !")
	end
end

function StartDriveTest(type)
	Framework.Game.SpawnVehicle(AutoEcole_Config.VehicleModels[type], AutoEcole_Config.Zones.VehicleSpawnPoint.pos, 317.0, function(vehicle)
		CurrentTest = 'drive'
		CurrentTestType = type
		CurrentCheckPoint = 0
		LastCheckPoint = -1
		CurrentZoneType = 'residence'
		DriveErrors = 0
		IsAboveSpeedLimit = false
		CurrentVehicle = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)
		local playerPed = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		local newPlate = Concess:GenerateSocietyPlate('DMV1')
		SetVehicleNumberPlateText(vehicle, newPlate)
		exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)
	end)

	exports["ac"]:ExecuteServerEvent('AutoEcole:pay', AutoEcole_Config.Prices[type])
end

function StopDriveTest(success)
	if success then
		exports["ac"]:ExecuteServerEvent('AutoEcole:addLicense', CurrentTestType)
		Framework.ShowNotification("Vous avez ~g~réussi~s~ le test !")
	else
		Framework.ShowNotification("Vous avez ~r~échouer~s~ le test !")
	end

	CurrentTest = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
	CurrentZoneType = type
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({openSection = 'question'})
	cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb('OK')
end)

-- Block UI
CreateThread(function()
	while true do
		wait = 1750

		if CurrentTest == 'theory' then
			wait = 10

			local playerPed = PlayerPedId()

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		end

		Wait(wait)
	end
end)

-- Drive test
CreateThread(function()
	while true do
		wait = 1600

		if CurrentTest == 'drive' then
			wait = 10

			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed, false)
			local nextCheckPoint = CurrentCheckPoint + 1

			if AutoEcole_Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				Framework.ShowNotification("Test de conduite terminé")

				if DriveErrors < AutoEcole_Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else
				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.x, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.y, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipColour(CurrentBlip, 27)
					SetBlipRoute(CurrentBlip, 1)
					SetBlipRouteColour(CurrentBlip, 27)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.x, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.y, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					wait = 1

					DrawMarker(27, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.x, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.y, AutoEcole_Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 255, false, false, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					AutoEcole_Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
		end

		Wait(wait)
	end
end)

-- Speed / Damage control
CreateThread(function()
	while true do
		wait = 1650

		if CurrentTest == 'drive' then
			wait = 10

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local speed = GetEntitySpeed(vehicle) * AutoEcole_Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k, v in pairs(AutoEcole_Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors = DriveErrors + 1
							IsAboveSpeedLimit = true

							Framework.ShowNotification("Vous roulez trop vite ! Vitesse limite: ~y~"..v)
							Framework.ShowNotification("Erreurs ~r~"..DriveErrors.."~s~/~p~"..AutoEcole_Config.MaxErrors)
						end
					end
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)

				if health < LastVehicleHealth then
					DriveErrors = DriveErrors + 1

					Framework.ShowNotification("Vous avez endommagé le véhicule !")
					Framework.ShowNotification("Erreurs ~r~"..DriveErrors.."~s~/~p~"..AutoEcole_Config.MaxErrors)
					LastVehicleHealth = health
				end
			end
		end

		Wait(wait)
	end
end)


