
AmbJob_firstSpawn = true;
AmbJob_isDead = true;

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function playerInCayo()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Coordonnées approximatives du centre de Cayo Perico et le rayon de détection
    local cayoCenter = vector3(5100.0, -5200.0, 0.0)  -- centre approximatif de Cayo Perico
    local radius = 800.0  -- rayon autour du centre

    -- Calcul de la distance entre le joueur et le centre de Cayo Perico
    local distance = #(playerCoords - cayoCenter)

    -- Vérifie si le joueur est dans le rayon défini
    return distance <= radius
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent("AmbulanceJob:setDeathStatus", 0)
  
	CreateThread(function()
		EndDeathCam()
		DoScreenFadeOut(800)
		local coordsRespawn = Config['job_ambulance'].RespawnCoords['ls'];
		--[[if playerInCayo() then
			coordsRespawn = Config['job_ambulance'].RespawnCoords['cayo']
		end]]
		--if Cayo.isInCayo then coordsRespawn = Config['job_ambulance'].RespawnCoords['cayo']; end
		RespawnPed(PlayerPedId(), { coords = coordsRespawn, heading = 90.0 })

		while not IsScreenFadedOut() do
		  Wait(1)
		end

		DoScreenFadeIn(800)
	end)
end

function RespawnPed(ped, spawn)
	SetEntityCoordsNoOffset(ped, spawn.coords, false, false, false, true)
	NetworkResurrectLocalPlayer(spawn.coords, 90.0, true, false)
	SetPlayerInvincible(ped, false)

	TriggerEvent('playerSpawned', spawn)
	ClearPedBloodDamage(ped)

	AmbJob_isDead = false;
end

function StartDistressSignal()
	CreateThread(function()
		local timer = (10 * 60000)

		while timer > 0 and AmbJob_isDead do
			Wait(1)

			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.0, 0.5)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextCentre(true)

			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName("Appuyez sur [~b~G~s~] pour envoyer un signal de détresse")
			EndTextCommandDisplayText(0.5, 0.85)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()

				break
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	TriggerServerEvent('playerDied:comaCall')
	--[[if not Cayo.isInCayo then
		--exports["lb-phone"]:SendCompanyMessage('ambulance', "Un citoyen est dans le besoin !", true)
		
		--exports["lb-phone"]:SendCompanyCoords('ambulance', coords, true)
--	else
--		exports["lb-phone"]:SendCompanyMessage('cayoems', "Un citoyen est dans le besoin !", true)
--		exports["lb-phone"]:SendCompanyCoords('cayoems', coords, true)
	end]]
	Framework.ShowNotification("Le signal de détresse a été envoyé aux unités disponibles !")
end

function ShowDeathTimer()
	local respawnTimer = (10 * 60000 / 1000)
	local allowRespawn = respawnTimer / 2

	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextCommandScaleformString("STRING")
	AddTextComponentSubstringPlayerName("~r~Vous etes dans le coma")
	EndTextCommandScaleformString()
	EndScaleformMovieMethod()

	PlaySoundFrontend(-1, "TextHit", "WastedSounds", true)

	CreateThread(function()
		while respawnTimer > 0 and AmbJob_isDead do
			Wait(1000)

			if respawnTimer > 0 then
				respawnTimer = respawnTimer - 1
			end
		end
	end)

	CreateThread(function()
		while respawnTimer > 0 and AmbJob_isDead do
			Wait(1)
			
			SetTextFont(4)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextCentre(true)

			local text = ("Réapparition dans ~b~%s minutes %s secondes~s~"):format(secondsToClock(respawnTimer))

			if respawnTimer <= allowRespawn then
				text = text .. "\n Appuyez sur [~b~E~w~] pour réapparaître."

				if IsControlJustReleased(0, 38) then
					RemoveItemsAfterRPDeath(true)
					break
				end
			end

			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end

		if respawnTimer <= 0 then
			RemoveItemsAfterRPDeath(true)
		end
	end)
end

AddEventHandler('framework:onPlayerDeath', function()
	AmbJob_isDead = true;
	TriggerServerEvent("AmbulanceJob:setDeathStatus", 1)
	ShowDeathTimer()
	StartDeathCam()
	StartDistressSignal()
end)

CreateThread(function()
	while true do
		Wait(0)
		if AmbJob_isDead then
			DisableControlAction(1, 249, true)
		end
	end
end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function()
	Wait(5000)
	AmbJob_isDead = false;
	ClearTimecycleModifier()
	SetPedMotionBlur(PlayerPedId(), false)
	ClearExtraTimecycleModifier()
	EndDeathCam()
	if AmbJob_firstSpawn then
		AmbJob_firstSpawn = false;
		Framework.TriggerServerCallback("AmbulanceJob:getDeathStatus", function(shouldDie)
			if shouldDie == 1 then
			 	Wait(1000)
			 	SetEntityHealth(PlayerPedId(), 0)
			end
		end)
	end
end)

RegisterNetEvent("AmbulanceJob:revive")
AddEventHandler("AmbulanceJob:revive", function()
	local plyPed = PlayerPedId()
	local coords = GetEntityCoords(plyPed, false)

	TriggerServerEvent("AmbulanceJob:setDeathStatus", 0)
	TriggerEvent('status:resetStatus')

	CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do Wait(1) end
		RespawnPed(plyPed, {coords = coords, heading = 0.0})
		AmbJob_isDead = false;
		ClearTimecycleModifier()
		SetPedMotionBlur(plyPed, false)
		ClearExtraTimecycleModifier()
		EndDeathCam()
		DoScreenFadeIn(800)
	end)
end)

function StartDeathCam()
end

function EndDeathCam()
	ClearFocus()
	RenderScriptCams(false, false, 0, true, false)
	DestroyAllCams(true)
	DestroyCam(cam, false)

	cam = nil
end

AmbulanceJob.reaPlayer = function(closestPlayer)
	Framework.TriggerServerCallback("AmbulanceJob:getItemAmount", function(qtty)
		if qtty > 0 then
            local tarPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(tarPed)
            
			if health == 0 then
                local plyPed = PlayerPedId()
                
				CreateThread(function()
					Framework.ShowNotification("Réanimation en Cours...")
                    TaskStartScenarioInPlace(plyPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                    Wait(10000)
                    ClearPedTasks(plyPed)

                    if GetEntityHealth(tarPed) == 0 then
						TriggerServerEvent("AmbulanceJob:revive", GetPlayerServerId(closestPlayer))
                    else
                      Framework.ShowNotification("La personne n'est pas inconsciente !")
					  print(health)
                    end
                end)
			else
				Framework.ShowNotification("La personne n'est pas inconsciente² !")
				print(health)
			end
		else
            Framework.ShowNotification("Vous n'avez pas de Défibrillateur !")
        end
    end, 'defibrillateur')
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t, i = {}, 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end
