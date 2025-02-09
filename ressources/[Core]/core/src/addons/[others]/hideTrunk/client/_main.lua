HideInTrunk = {}

HideInTrunk.inTrunk = false;

function HideInTrunk:Cam(coords)
    DestroyAllCams(true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0.0, 0.0, 0.0, 0.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
end

CreateThread(function()
    while true do
        wait = 1500

        local plyPed = PlayerPedId()

        if HideInTrunk.inTrunk then
            wait = 1;
            local vehicle = GetEntityAttachedTo(plyPed)

            if DoesEntityExist(vehicle) or not IsPedDeadOrDying(plyPed) or not IsPedFatallyInjured(plyPed) then
                local coords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))

                HideInTrunk:Cam(coords)
                DisplayRadar(false)

                if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
                    SetEntityVisible(plyPed, false, false)
                else
                    if not IsEntityPlayingAnim(plyPed, 'timetable@floyd@cryingonbed@base', 3) then
                        loadDict('timetable@floyd@cryingonbed@base')
                        TaskPlayAnim(plyPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

                        SetEntityVisible(plyPed, true, false)
                    end
                end

                Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour sortir du Coffre")

                if IsControlJustReleased(0, 38) and HideInTrunk.inTrunk then
                    DisplayRadar(true)
                    RenderScriptCams(false, false, 0, true, false)
                    SetCarBootOpen(vehicle)
                    SetEntityCollision(plyPed, true, true)
                    Wait(750)
                    HideInTrunk.inTrunk = false;
                    DetachEntity(plyPed, true, true)
                    SetEntityVisible(plyPed, true, false)
                    ClearPedTasks(plyPed)
                    SetEntityCoords(plyPed, GetOffsetFromEntityInWorldCoords(plyPed, 0.0, -0.5, -0.75))
                    Wait(250)
                    SetVehicleDoorShut(vehicle, 5)
                end

            else
                SetEntityCollision(plyPed, true, true)
                DetachEntity(plyPed, true, true)
                SetEntityVisible(plyPed, true, false)
                ClearPedTasks(plyPed)
                SetEntityCoords(plyPed, GetOffsetFromEntityInWorldCoords(plyPed, 0.0, -0.5, -0.75))
            end
        end

        Wait(wait)
    end
end)   

CreateThread(function()
    while true do
        wait = 750;
        
        local plyPed = PlayerPedId()
        local vehicle = GetClosestVehicle(GetEntityCoords(plyPed), 10.0, 0, 70)
		local lockStatus = GetVehicleDoorLockStatus(vehicle)

        if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle,-1) then
            local trunk = GetEntityBoneIndexByName(vehicle, 'boot')

            if trunk ~= -1 then
                local coords = GetWorldPositionOfEntityBone(vehicle, trunk)

                if GetDistanceBetweenCoords(GetEntityCoords(plyPed), coords, true) <= 1.5 then
                    wait = 1;

                    if not HideInTrunk.inTrunk then
                        if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
                            VisualManager:DrawText3D(vector3(coords.x, coords.y, coords.z), "[E] Se Cacher \n [H] Ouvrir")

                            if IsControlJustReleased(0, 74)then
                                if lockStatus == 1 then
                                    SetCarBootOpen(vehicle)
                                elseif lockStatus == 2 then
                                    Framework.ShowNotification("~r~Le véhicule est verouiller !~s~")
                                end
                            end
                        else
                            VisualManager:DrawText3D(vector3(coords.x, coords.y, coords.z), "[E] Se Cacher \n [H] Ouvrir")
                            if IsControlJustReleased(0, 74) then
                                SetVehicleDoorShut(vehicle, 5)
                            end
                        end
                    end

                    if IsControlJustReleased(0, 38) and not HideInTrunk.inTrunk then
                        local player = Framework.Game.GetClosestPlayer()
                        local targetPed = GetPlayerPed(player)
						local plyPed = PlayerPedId()
						if lockStatus == 1 then
							if DoesEntityExist(targetPed) then
								if not IsEntityAttached(targetPed) or GetDistanceBetweenCoords(GetEntityCoords(targetPed), GetEntityCoords(plyPed), true) >= 5.0 then
									SetCarBootOpen(vehicle)
									Wait(350)
									AttachEntityToEntity(plyPed, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
									loadDict('timetable@floyd@cryingonbed@base')
									TaskPlayAnim(targetPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
									Wait(50)
									HideInTrunk.inTrunk = true;

									Wait(1500)
									SetVehicleDoorShut(vehicle, 5)
								else
                                    Framework.ShowNotification("~r~Il y a déjà quelqu'un dans le coffre !~s~")
								end
							end
						elseif lockStatus == 2 then
                            Framework.ShowNotification("~r~Le véhicule est verouiller !~s~")
						end
                    end

                end
            end
        end

        Wait(wait)
    end
end)

function loadDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(100) RequestAnimDict(dict) end
end