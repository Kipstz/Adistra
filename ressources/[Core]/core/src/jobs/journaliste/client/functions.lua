
JournalisteJob.holdingCam, JournalisteJob.usingCam = false, false;
JournalisteJob.holdingMic, JournalisteJob.usingMic = false, false;
JournalisteJob.holdingBmic, JournalisteJob.usingBmic = false, false;

JournalisteJob.camModel, JournalisteJob.camanimDict, JournalisteJob.camanimName = "prop_v_cam_01", "missfinale_c2mcs_1", "fin_c2_mcs_1_camman";
JournalisteJob.micModel, JournalisteJob.micanimDict, JournalisteJob.micanimName = "p_ing_microphonel_01", "missheistdocksprep1hold_cellphone", "hold_cellphone";
JournalisteJob.bmicModel, JournalisteJob.bmicanimDict, JournalisteJob.bmicanimName = "prop_v_bmike_01", "missfra1", "mcs2_crew_idle_m_boom";

JournalisteJob.bmic_net , JournalisteJob.mic_net, JournalisteJob.cam_net = nil, nil, nil;

JournalisteJob.UI = { 
	x =  0.000 ,
	y = -0.001 ,
}

---------------------------------------------------------------------------
-- Toggling Cam --
---------------------------------------------------------------------------
RegisterNetEvent("JournalisteJob:toggleCam")
AddEventHandler("JournalisteJob:toggleCam", function()
    local plyPed = PlayerPedId()

    if not JournalisteJob.holdingCam then
        ExecuteCommand('hud')
        local plyCoords = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 0.0, -5.0)

        Framework.Game.SpawnObject(JournalisteJob.camModel, plyCoords, function(obj)
            local netid = ObjToNet(obj)
            SetNetworkIdExistsOnAllMachines(netid, true)
            NetworkSetNetworkIdDynamic(netid, true)
            SetNetworkIdCanMigrate(netid, false)

            while not HasAnimDictLoaded(JournalisteJob.camanimDict) do
				RequestAnimDict(JournalisteJob.camanimDict)
				Wait(100)
			end

            AttachEntityToEntity(obj, plyPed, GetPedBoneIndex(plyPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            TaskPlayAnim(plyPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
            TaskPlayAnim(plyPed, JournalisteJob.camanimDict, JournalisteJob.camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)

            JournalisteJob.cam_net = netid;
            JournalisteJob.holdingCam = true;

            JournalisteJob:DisplayNotification("To enter News cam press ~INPUT_PICKUP~ \nTo Enter Movie Cam press ~INPUT_INTERACTION_MENU~")
        end)
    else
        ExecuteCommand('hud')
        ClearPedSecondaryTask(plyPed)
        DetachEntity(NetToObj(JournalisteJob.cam_net), 1, 1)
        DeleteEntity(NetToObj(JournalisteJob.cam_net))

        JournalisteJob.cam_net = nil;
        JournalisteJob.holdingCam = false;
        JournalisteJob.usingCam = false;
    end
end)

CreateThread(function()
	while true do
        wait = 5000;

		if JournalisteJob.holdingCam then
            wait = 1;
            local plyPed = PlayerPedId()

			while not HasAnimDictLoaded(JournalisteJob.camanimDict) do
				RequestAnimDict(JournalisteJob.camanimDict)
				Wait(100)
			end

			if not IsEntityPlayingAnim(plyPed, JournalisteJob.camanimDict, JournalisteJob.camanimName, 3) then
				TaskPlayAnim(plyPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
				TaskPlayAnim(plyPed, JournalisteJob.camanimDict, JournalisteJob.camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end
				
			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0, 44,  true) -- INPUT_COVER
			DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
			SetCurrentPedWeapon(plyPed, GetHashKey("WEAPON_UNARMED"), true)
		end

        Wait(wait)
	end
end)

---------------------------------------------------------------------------
-- Cam Functions --
---------------------------------------------------------------------------

local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0

local camera = false
local fov = (fov_max+fov_min)*0.5

---------------------------------------------------------------------------
-- Movie Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
        wait = 2500;

		local plyPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(plyPed)

		if JournalisteJob.holdingCam then
            wait = 1;

            if IsControlJustReleased(1, 244) then
                movcamera = true

                SetTimecycleModifier("default")
                SetTimecycleModifierStrength(0.3)
			
                local scaleform = RequestScaleformMovie("security_camera")
                while not HasScaleformMovieLoaded(scaleform) do Wait(100) end

                local cam1 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

                AttachCamToEntity(cam1, plyPed, 0.0,0.0,1.0, true)
                SetCamRot(cam1, 2.0, 1.0, GetEntityHeading(plyPed))
                SetCamFov(cam1, fov)
                RenderScriptCams(true, false, 0, 1, 0)
                PushScaleformMovieFunction(scaleform, "security_camera")
                PopScaleformMovieFunctionVoid()

                while movcamera and not IsEntityDead(plyPed) and (GetVehiclePedIsIn(plyPed) == veh) and true do
                    if IsControlJustPressed(0, 177) then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        movcamera = false
                    end
				
                    SetEntityRotation(plyPed, 0, 0, new_z,2, true)

                    local zoomvalue = (1.0/(fov_max - fov_min))*(fov - fov_min)
                    JournalisteJob:CheckInputRotation(cam1, zoomvalue)
                    JournalisteJob:HandleZoom(cam1)
                    JournalisteJob:HideHUDThisFrame()
                    JournalisteJob:drawRct(JournalisteJob.UI.x + 0.0, JournalisteJob.UI.y + 0.0, 1.0,0.15,0,0,0,255) -- Top Bar
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    JournalisteJob:drawRct(JournalisteJob.UI.x + 0.0, JournalisteJob.UI.y + 0.85, 1.0,0.16,0,0,0,255) -- Bottom Bar
				
                    local camHeading = GetGameplayCamRelativeHeading()
                    local camPitch = GetGameplayCamRelativePitch()
                    if camPitch < -70.0 then
                        camPitch = -70.0
                    elseif camPitch > 42.0 then
                        camPitch = 42.0
                    end
                    camPitch = (camPitch + 70.0) / 112.0
				
                    if camHeading < -180.0 then
                        camHeading = -180.0
                    elseif camHeading > 180.0 then
                        camHeading = 180.0
                    end
                    camHeading = (camHeading + 180.0) / 360.0
				
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, plyPed, "Pitch", camPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, plyPed, "Heading", camHeading * -1.0 + 1.0)
                    
                    Wait(1)
                end

                movcamera = false;

                ClearTimecycleModifier()
    
                fov = (fov_max + fov_min)*0.5
    
                RenderScriptCams(false, false, 0, 1, 0)
                SetScaleformMovieAsNoLongerNeeded(scaleform)
                DestroyCam(cam1, false)
                SetNightvision(false)
                SetSeethrough(false)
			end
		end
        Wait(wait)
	end
end)

---------------------------------------------------------------------------
-- News Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
        wait = 2500;

		local plyPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(plyPed)

		if JournalisteJob.holdingCam then
            wait = 1;

            if IsControlJustReleased(1, 38) then
                newscamera = true

                SetTimecycleModifier("default")
                SetTimecycleModifierStrength(0.3)
			
                local scaleform = RequestScaleformMovie("security_camera")
                local scaleform2 = RequestScaleformMovie("breaking_news")
                while not HasScaleformMovieLoaded(scaleform) do Wait(100) end
                while not HasScaleformMovieLoaded(scaleform2) do Wait(100) end

                local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

                AttachCamToEntity(cam2, plyPed, 0.0, 0.0, 1.0, true)
                SetCamRot(cam2, 2.0, 1.0, GetEntityHeading(plyPed))
                SetCamFov(cam2, fov)
                RenderScriptCams(true, false, 0, 1, 0)
                PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
                PushScaleformMovieFunction(scaleform2, "breaking_news")
                PopScaleformMovieFunctionVoid()

                while newscamera and not IsEntityDead(plyPed) and (GetVehiclePedIsIn(plyPed) == veh) and true do
                    if IsControlJustPressed(1, 177) then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        newscamera = false
                    end

                    SetEntityRotation(lPed, 0, 0, new_z,2, true)
					
                    local zoomvalue = (1.0/(fov_max - fov_min))*(fov - fov_min)

                    JournalisteJob:CheckInputRotation(cam2, zoomvalue)
                    JournalisteJob:HandleZoom(cam2)
                    JournalisteJob:HideHUDThisFrame()

                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
                    JournalisteJob:Breaking("BREAKING NEWS")
				
                    local camHeading = GetGameplayCamRelativeHeading()
                    local camPitch = GetGameplayCamRelativePitch()
                    if camPitch < -70.0 then
                        camPitch = -70.0
                    elseif camPitch > 42.0 then
                        camPitch = 42.0
                    end
                    camPitch = (camPitch + 70.0) / 112.0
                    
                    if camHeading < -180.0 then
                        camHeading = -180.0
                    elseif camHeading > 180.0 then
                        camHeading = 180.0
                    end
                    camHeading = (camHeading + 180.0) / 360.0
				
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, plyPed, "Pitch", camPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, plyPed, "Heading", camHeading * -1.0 + 1.0)
				
                    Wait(1)
                end

                newscamera = false;

                ClearTimecycleModifier()
    
                fov = (fov_max + fov_min)*0.5
    
                RenderScriptCams(false, false, 0, 1, 0)
                SetScaleformMovieAsNoLongerNeeded(scaleform)
                DestroyCam(cam2, false)
                SetNightvision(false)
                SetSeethrough(false)
			end
		end
        Wait(wait)
	end
end)

---------------------------------------------------------------------------
-- Events --
---------------------------------------------------------------------------

-- Activate camera
RegisterNetEvent('JournalisteJob:camActivate')
AddEventHandler('JournalisteJob:camActivate', function()
	camera = not camera
end)

--FUNCTIONS--
function JournalisteJob:HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function JournalisteJob:CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function JournalisteJob:HandleZoom(cam)
	local plyPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(plyPed) then
		if IsControlJustPressed(0, 241) then fov = math.max(fov - zoomspeed, fov_min) end
		if IsControlJustPressed(0, 242) then fov = math.min(fov + zoomspeed, fov_max) end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then fov = current_fov end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0, 17) then fov = math.max(fov - zoomspeed, fov_min) end
		if IsControlJustPressed(0, 16) then fov = math.min(fov + zoomspeed, fov_max) end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then fov = current_fov end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end

---------------------------------------------------------------------------
-- Toggling Mic --
---------------------------------------------------------------------------
RegisterNetEvent("JournalisteJob:toggleMic")
AddEventHandler("JournalisteJob:toggleMic", function()
    local plyPed = PlayerPedId()

    if not JournalisteJob.holdingMic then
        local plyCoords = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 0.0, -5.0)

        Framework.Game.SpawnObject(JournalisteJob.micModel, plyCoords, function(obj)
            local netid = ObjToNet(obj)
            SetNetworkIdExistsOnAllMachines(netid, true)
            NetworkSetNetworkIdDynamic(netid, true)
            SetNetworkIdCanMigrate(netid, false)

            while not HasAnimDictLoaded(JournalisteJob.micanimDict) do
                RequestAnimDict(JournalisteJob.micanimDict)
                Wait(100)
            end

            AttachEntityToEntity(obj, plyPed, GetPedBoneIndex(plyPed, 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            TaskPlayAnim(plyPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
            TaskPlayAnim(plyPed, JournalisteJob.micanimDict, JournalisteJob.micanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
            JournalisteJob.mic_net = netid;
            JournalisteJob.holdingMic = true;
        end)
    else
        ClearPedSecondaryTask(plyPed)
        DetachEntity(NetToObj(JournalisteJob.mic_net), 1, 1)
        DeleteEntity(NetToObj(JournalisteJob.mic_net))

        JournalisteJob.mic_net = nil;
        JournalisteJob.holdingMic = false;
        JournalisteJob.usingMic = false;
    end
end)

---------------------------------------------------------------------------
-- Toggling Boom Mic --
---------------------------------------------------------------------------
RegisterNetEvent("JournalisteJob:toggleBMic")
AddEventHandler("JournalisteJob:toggleBMic", function()
    local plyPed = PlayerPedId()

    if not JournalisteJob.holdingBmic then
        local plyCoords = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 0.0, -5.0)

        Framework.Game.SpawnObject(JournalisteJob.bmicModel, plyCoords, function(obj)
            local netid = ObjToNet(obj)
            SetNetworkIdExistsOnAllMachines(netid, true)
            NetworkSetNetworkIdDynamic(netid, true)
            SetNetworkIdCanMigrate(netid, false)

            AttachEntityToEntity(obj, plyPed, GetPedBoneIndex(plyPed, 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            TaskPlayAnim(plyPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
            TaskPlayAnim(plyPed, JournalisteJob.bmicanimDict, JournalisteJob.bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
            JournalisteJob.bmic_net = netid;
            JournalisteJob.holdingBmic = true;
        end)
    else
        ClearPedSecondaryTask(plyPed)
        DetachEntity(NetToObj(JournalisteJob.bmic_net), 1, 1)
        DeleteEntity(NetToObj(JournalisteJob.bmic_net))

        JournalisteJob.bmic_net = nil;
        JournalisteJob.holdingBmic = false;
        JournalisteJob.usingBmic = false;
    end
end)

CreateThread(function()
	while true do
        wait = 2500;

		if JournalisteJob.holdingBmic then
            local plyPed = PlayerPedId()

			while not HasAnimDictLoaded(JournalisteJob.bmicanimDict) do
				RequestAnimDict(JournalisteJob.bmicanimDict)
				Wait(100)
			end

			if not IsEntityPlayingAnim(plyPed, JournalisteJob.bmicanimDict, JournalisteJob.bmicanimName, 3) then
				TaskPlayAnim(plyPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
				TaskPlayAnim(plyPed, JournalisteJob.bmicanimDict, JournalisteJob.bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end
			
			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0, 44,  true) -- INPUT_COVER
			DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
			SetCurrentPedWeapon(plyPed, GetHashKey("WEAPON_UNARMED"), true)
			
			if (IsPedInAnyVehicle(plyPed, -1) and GetPedVehicleSeat(plyPed) == -1) or IsPedCuffed(plyPed) or JournalisteJob.holdingMic then
				ClearPedSecondaryTask(plyPed)
				DetachEntity(NetToObj(JournalisteJob.bmic_net), 1, 1)
				DeleteEntity(NetToObj(JournalisteJob.bmic_net))
				JournalisteJob.bmic_net = nil
				JournalisteJob.holdingBmic = false
				JournalisteJob.usingBmic = false
			end
		end

        Wait(wait)
	end
end)

---------------------------------------------------------------------------------------
-- Misc functions --
---------------------------------------------------------------------------------------

function JournalisteJob:drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function JournalisteJob:Breaking(text)
    SetTextColour(255, 255, 255, 255)
    SetTextFont(8)
    SetTextScale(1.2, 1.2)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.2, 0.85)
end

function JournalisteJob:DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
