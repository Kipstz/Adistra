local uiFaded = false

CreateThread(function()
    while Framework.PlayerData == nil or Framework.PlayerData.accounts == nil do
        Wait(100)
    end
		TriggerEvent("hud:update")
		Status:GetStatus('hunger', function(hunger)
			myhunger = hunger.getPercent()
		end)

		Status:GetStatus('hunger', function(hunger)
			myhunger = hunger.getPercent()
		end)

		Status:GetStatus('thirst', function(thirst)
			mythirst = thirst.getPercent()
		end)
		SendNUIMessage({
			type = "updateHUD",
			bank = Framework.PlayerData.accounts['bank'].money,
			cash = Framework.PlayerData.accounts['money'].money,
			playerId = GetPlayerServerId(PlayerId()),
			--players = countPlayers,
			hunger = math.round(myhunger),
			thirst = math.round(mythirst)
		})

end)

RegisterNetEvent('hud:update')
AddEventHandler('hud:update', function()
    if Framework.PlayerData ~= nil then
		Status:GetStatus('hunger', function(hunger)
			myhunger = hunger.getPercent()
		end)

		Status:GetStatus('hunger', function(hunger)
			myhunger = hunger.getPercent()
		end)

		Status:GetStatus('thirst', function(thirst)
			mythirst = thirst.getPercent()
		end)
		SendNUIMessage({
			type = "updateHUD",
			bank = Framework.PlayerData.accounts['bank'].money,
			cash = Framework.PlayerData.accounts['money'].money,
			playerId = GetPlayerServerId(PlayerId()),
			--players = countPlayers,
			hunger = math.round(myhunger),
			thirst = math.round(mythirst)
		})
	end
end)

RegisterCommand('hud', function()
	uiFaded = not uiFaded

	if uiFaded then
		SendNUIMessage({action = 'fadeUi', value = true})
	else
		SendNUIMessage({action = 'fadeUi', value = false})
	end
end)

CreateThread(function()
	while true do
		wait = 1750

		if not uiFaded then
			wait = 750

			if IsPauseMenuActive() or IsPlayerSwitchInProgress() then
				if not inFrontend then
					inFrontend = true
					SendNUIMessage({action = 'hideUi', value = true})
				end
			else
				if inFrontend then
					inFrontend = false
					SendNUIMessage({action = 'hideUi', value = false})
				end
			end
		end

		Wait(wait)
	end
end)

CreateThread(function()
	while true do
		Wait(5000)
		Status:GetStatus('hunger', function(hunger)
			myhunger = hunger.getPercent()
		end)

		Status:GetStatus('hunger', function(hunger)
			myhunger = hunger.getPercent()
		end)

		Status:GetStatus('thirst', function(thirst)
			mythirst = thirst.getPercent()
		end)

		SendNUIMessage({
			type = "updateHUD",
			bank = Framework.PlayerData.accounts['bank'].money,
			cash = Framework.PlayerData.accounts['money'].money,
			playerId = GetPlayerServerId(PlayerId()),
			--players = countPlayers,
			hunger = math.round(myhunger),
			thirst = math.round(mythirst)
		})
	end
end)

RegisterCommand("togglehud", function()
    isHudVisible = not isHudVisible
    SendNUIMessage({
        type = "toggleHud",
        show = isHudVisible
    })
end, false)


local showSpeedo = true

CreateThread(function()
	while true do
		wait = 2500
		
		local plyPed = PlayerPedId()
		local inVeh = IsPedInAnyVehicle(plyPed)
		local vehicle = GetVehiclePedIsIn(plyPed, false)
		local driver = GetPedInVehicleSeat(vehicle, -1)

		if inVeh and driver == plyPed and showSpeedo then
			wait = 100

			if vehicle then
				carSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.6)

				SendNUIMessage({
					showhud = true,
					speed = carSpeed
				})

				_, feuPosition, feuRoute = GetVehicleLightsState(vehicle)

				if feuPosition == 1 and feuRoute == 0 then
					SendNUIMessage({
						feuPosition = true
					})
				else
					SendNUIMessage({
						feuPosition = false
					})
				end

				if feuPosition == 1 and feuRoute == 1 then
					SendNUIMessage({
						feuRoute = true
					})
				else
					SendNUIMessage({
						feuRoute = false
					})
				end

				local fuel = GetVehicleFuelLevel(vehicle)

				SendNUIMessage({
					showfuel = true,
					fuel = fuel
				})
			else
				SendNUIMessage({
					showhud = false
				})
			end
		else
			SendNUIMessage({
				showhud = false
			})
		end

		Wait(wait)
	end
end)

RegisterCommand('speedometer', function()
	showSpeedo = not showSpeedo

	if showSpeedo then
		SendNUIMessage({
			showhud = true
		})
	else
		SendNUIMessage({
			showhud = false
		})
	end
end)