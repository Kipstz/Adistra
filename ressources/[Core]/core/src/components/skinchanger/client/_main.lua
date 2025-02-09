SkinChanger = {}

SkinChanger.LastSkin = nil
SkinChanger.cam = nil
SkinChanger.isCameraActive = nil
SkinChanger.FirstSpawn = true 
SkinChanger.zoomOffset = 0.0
SkinChanger.camOffset = 0.0 
SkinChanger.heading = 90.0

function SkinChanger.CreateSkinCam()
	if not DoesCamExist(SkinChanger.cam) then
		SkinChanger.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(SkinChanger.cam, true)
	RenderScriptCams(true, true, 500, true, true)

	SkinChanger.isCameraActive = true
	
	SetCamRot(SkinChanger.cam, 0.0, 0.0, 270.0, true)
	SetEntityHeading(PlayerPedId(), 90.0)
end

function SkinChanger.DeleteSkinCam()
	SkinChanger.isCameraActive = false

	SetCamActive(SkinChanger.cam, false)
	RenderScriptCams(false, true, 500, true, true)

	SkinChanger.cam = nil
end

CreateThread(function()
	while true do
		wait = 1500

		if SkinChanger.isCameraActive then
			wait = 1
			DisableControlAction(2, 30, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(2, 33, true)
			DisableControlAction(2, 34, true)
			DisableControlAction(2, 35, true)
			DisableControlAction(0, 25, true) -- Input Aim
			DisableControlAction(0, 24, true) -- Input Attack

			local plyPed = PlayerPedId()
			local coords = GetEntityCoords(plyPed, false)

			local angle = SkinChanger.heading * math.pi / 180.0

			local theta = {
				x = math.cos(angle),
				y = math.sin(angle)
			}

			local pos = {
				x = coords.x + (SkinChanger.zoomOffset * theta.x),
				y = coords.y + (SkinChanger.zoomOffset * theta.y)
			}

			local angleToLook = SkinChanger.heading - 140.0

			if angleToLook > 360 then
				angleToLook = angleToLook - 360
			elseif angleToLook < 0 then
				angleToLook = angleToLook + 360
			end

			angleToLook = angleToLook * math.pi / 180.0

			local thetaToLook = {
				x = math.cos(angleToLook),
				y = math.sin(angleToLook)
			}

			local posToLook = {
				x = coords.x + (SkinChanger.zoomOffset * thetaToLook.x),
				y = coords.y + (SkinChanger.zoomOffset * thetaToLook.y),
			}

			SetCamCoord(SkinChanger.cam, pos.x, pos.y, coords.z + SkinChanger.camOffset)
			PointCamAtCoord(SkinChanger.cam, posToLook.x, posToLook.y, coords.z + SkinChanger.camOffset)
		end

		Wait(wait)
	end
end)

CreateThread(function()
	SkinChanger.angle = 90

	while true do
		wait = 1300

		if SkinChanger.isCameraActive then
			wait = 1

			if IsDisabledControlPressed(0, 108) then
				SkinChanger.angle = SkinChanger.angle - 1
			elseif IsDisabledControlPressed(0, 109) then
				SkinChanger.angle = SkinChanger.angle + 1
			end

			if SkinChanger.angle > 360 then
				SkinChanger.angle = SkinChanger.angle - 360
			elseif SkinChanger.angle < 0 then
				SkinChanger.angle = SkinChanger.angle + 360
			end

			SkinChanger.heading = SkinChanger.angle + 0.0
		end

		Wait(wait)
	end
end)

function SkinChanger.OpenSaveableMenu()
    TriggerEvent('skinchanger:getSkin', function(skin) SkinChanger.LastSkin = skin end)

	SkinChanger.OpenMenu()
end

function SkinChanger.ReloadSkinPlayer()
	Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin) 
	end)
	Wait(250)
	TatoosShop:reloadTattoos()
end

function SkinChanger.ReloadTotalSkinPlayer()
	SkinChanger.LastSex = -1
	
	Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin, jobSkin)
		if skin == nil then
			TriggerEvent('skinchanger:loadSkin', {sex = 0})
		else
			TriggerEvent('skinchanger:loadSkin', skin)
		end
	end)
end

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
    TriggerServerEvent('skinchanger:setWeight', xPlayer.skin.bags_1)
end)

AddEventHandler('skinchanger:getLastSkin', function(cb)
	cb(SkinChanger.LastSkin)
end)

AddEventHandler('skinchanger:setLastSkin', function(skin)
	SkinChanger.LastSkin = skin
end)

RegisterNetEvent('skinchanger:openMenu')
AddEventHandler('skinchanger:openMenu', function()
	SkinChanger.OpenMenu()
end)

RegisterNetEvent('skinchanger:openRestrictedMenu')
AddEventHandler('skinchanger:openRestrictedMenu', function()
	SkinChanger.OpenMenu()
end)

RegisterNetEvent('skinchanger:openSaveableMenu')
AddEventHandler('skinchanger:openSaveableMenu', function()
	SkinChanger.OpenSaveableMenu()
end)

RegisterNetEvent('skinchanger:openSaveableRestrictedMenu')
AddEventHandler('skinchanger:openSaveableRestrictedMenu', function()
	SkinChanger.OpenSaveableMenu()
end)
