
Smoke.Chicha = {}

Smoke.Chicha.start = false;
Smoke.Chicha.startedSession = false;

RegisterNetEvent('smoke:startChicha')
AddEventHandler('smoke:startChicha', function()
    local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)

    Framework.Game.SpawnObject(4037417364, vector3(0.0, 0.0, 70.0), function(obj)
        Smoke.Chicha.start = true;
        Smoke.Chicha.obj = obj;
        local boneIndex = GetPedBoneIndex(plyPed, 24818)
        Smoke.Chicha:Anim()
        AttachEntityToEntity(obj, plyPed, boneIndex, -0.15, 0.2, 0.18, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
    end)
end)

RegisterNetEvent('smoke:stopChicha')
AddEventHandler('smoke:stopChicha', function()
    local plyPed = PlayerPedId()

    ClearPedTasksImmediately(plyPed)
    if Smoke.Chicha.obj then DeleteObject(Smoke.Chicha.obj) end
    if Smoke.Chicha.obj2 then DeleteObject(Smoke.Chicha.obj2) end
    if Smoke.Chicha.start then Framework.ShowNotification("~r~Votre chicha est vide !~s~") end
    Smoke.Chicha.start = false;
    Smoke.Chicha.startedSession = false;
end)

CreateThread(function()
    while true do
        wait = 2500;

        if Smoke.Chicha.start then
            wait = 1;

            if IsControlJustReleased(0, 23) then
                Smoke.Chicha.start = false;
                if Smoke.Chicha.obj then DeleteObject(Smoke.Chicha.obj) end
                if Smoke.Chicha.obj2 then DeleteObject(Smoke.Chicha.obj2) end
                ClearPedTasksImmediately(PlayerPedId())
            end

            if not Smoke.Chicha.startedSession then
                if IsControlJustReleased(0, 311) then
                    Smoke.Chicha.startedSession = true;

                    local plyPed = PlayerPedId()
                    local myCoords = GetEntityCoords(plyPed)
                    local boneIndex = GetPedBoneIndex(plyPed, 12844)
                    local boneIndex2 = GetPedBoneIndex(plyPed, 24818)
                
                    Framework.Game.SpawnObject('v_corp_lngestoolfd', vector3(myCoords.x+0.5, myCoords.y+0.1, myCoords.z+0.4), function(obj)
                        Smoke.Chicha.obj2 = obj;
                        AttachEntityToEntity(obj, plyPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)	
                    end)

                    SetTimeout(60000, function()
                        Smoke.Chicha.startedSession = false;
                        TriggerServerEvent("smoke:chicha_smokes", PedToNet(PlayerPedId()))
                        if Smoke.Chicha.obj2 then DeleteObject(Smoke.Chicha.obj2) end
                        Framework.ShowNotification("~r~Votre session de tir à atteint son maximum !~s~")
                    end)
                end
            else
                if IsControlJustPressed(0, 74) then
                    Smoke.Chicha.startedSession = false;
                    TriggerServerEvent("smoke:chicha_smokes", PedToNet(PlayerPedId()))
                    if Smoke.Chicha.obj2 then DeleteObject(Smoke.Chicha.obj2) end
                end
            end
        end

        Wait(wait)
    end
end)

function Smoke.Chicha:Anim()
    local plyPed = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards";
	local anim = "ped_a_enter_loop";
	while not HasAnimDictLoaded(ad) do Wait(100) RequestAnimDict(ad) end
	TaskPlayAnim(plyPed, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end

RegisterNetEvent("smoke:chicha_smokes")
AddEventHandler("smoke:chicha_smokes", function(c_ped)
	local p_smoke_location = {
		20279,
	}

	local name = "scr_agency3b_elec_box"
	local dict = "scr_agencyheistb" 
	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
            RequestNamedPtfxAsset(dict)
            while not HasNamedPtfxAssetLoaded(dict) do Wait(100) end

			createdSmoke = UseParticleFxAssetNextCall(dict)
			createdPart = StartParticleFxLoopedOnEntityBone(name, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 5.0, 0.0, 0.0, 0.0)
            Wait(1000)

			StopParticleFxLooped(createdSmoke, 1)

			Wait(1000*2)

			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)