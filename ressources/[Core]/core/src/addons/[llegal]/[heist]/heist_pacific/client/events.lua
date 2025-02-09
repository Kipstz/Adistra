
RegisterNetEvent('framework:setJob')
AddEventHandler('framework:setJob', function(job)
    Config['heist_pacific'].stage0break = true;
    Config['heist_pacific'].stage1break = true;
    Config['heist_pacific'].stage2break = true;
    Config['heist_pacific'].stage3break = true;
    Config['heist_pacific'].stage4break = true;
    Config['heist_pacific'].stagelootbreak = true;
    Config['heist_pacific'].disableinput = false;
    Config['heist_pacific'].cur = 7;
    Config['heist_pacific'].starttimer = false;
    Config['heist_pacific'].vaulttime = 0;
    Config['heist_pacific'].alarmblip = nil;
    Config['heist_pacific'].grabber = false;

    Config['heist_pacific'].searchlocations = {
        {coords = {x = 233.40, y = 221.53, z = 110.40}, status = false},
        {coords = {x = 240.93, y = 211.12, z = 110.40}, status = false},
        {coords = {x = 246.54, y = 208.86, z = 110.40}, status = false},
        {coords = {x = 264.33, y = 212.16, z = 110.40}, status = false},
        {coords = {x = 252.87, y = 222.36, z = 106.35}, status = false},
        {coords = {x = 249.71, y = 227.84, z = 106.35}, status = false},
        {coords = {x = 244.80, y = 229.70, z = 106.35}, status = false}
    }

    Config['heist_pacific'].checks.hack1 = false;
    Config['heist_pacific'].checks.hack2 = false;
    Config['heist_pacific'].checks.thermal1 = false;
    Config['heist_pacific'].checks.thermal2 = false;
    Config['heist_pacific'].checks.id1 = false;
    Config['heist_pacific'].checks.id2 = false;
    Config['heist_pacific'].checks.idfound = false;
    Config['heist_pacific'].checks.grab1 = false;
    Config['heist_pacific'].checks.grab2 = false;
    Config['heist_pacific'].checks.grab3 = false;
    Config['heist_pacific'].checks.grab4 = false;
    Config['heist_pacific'].checks.grab5 = false;
    Config['heist_pacific'].searchinfo = {
        random = math.random(1, Config['heist_pacific'].cur),
        found = false
    }

    PacificHeist.program = 0;
    PacificHeist.scaleform = nil;
    PacificHeist.lives = 5;
    PacificHeist.ClickReturn = nil;
    PacificHeist.SorF = false;
    PacificHeist.Hacking = false;
    PacificHeist.UsingComputer = false;

    Wait(5000)

    Config['heist_pacific'].hackfinish = false;
    Config['heist_pacific'].stagelootbreak = false;
    Config['heist_pacific'].stage0break = false;
    Config['heist_pacific'].stage1break = false;
    Config['heist_pacific'].stage2break = false;
    Config['heist_pacific'].stage3break = false;
    Config['heist_pacific'].stage4break = false;
    Config['heist_pacific'].initiator = false;
    PacificHeist:GetInfo()
end)

RegisterNetEvent("heist_pacific:reset")
AddEventHandler("heist_pacific:reset", function()
    Config['heist_pacific'].stage1break = true;
    Config['heist_pacific'].stage2break = true;
    Config['heist_pacific'].stage4break = true;
    Config['heist_pacific'].stagelootbreak = false;
    Config['heist_pacific'].disableinput = false;
    Config['heist_pacific'].info = {stage = 0, style = nil, locked = false}
    Config['heist_pacific'].cur = 7;
    Config['heist_pacific'].starttimer = false;
    Config['heist_pacific'].vaulttime = 0;
    Config['heist_pacific'].alarmblip = nil;
    Config['heist_pacific'].grabber = false;

    Config['heist_pacific'].doorchecks = {
        {x= 257.10, y = 220.30, z = 106.28, he = 339.733, h = GetHashKey("hei_v_ilev_bk_gate_pris"), status = 0},
        {x = 236.91, y = 227.50, z = 106.29, he = 340.000, h = GetHashKey("v_ilev_bk_door"), status = 0},
        {x = 262.35, y = 223.00, z = 107.05, he = 249.731, h = GetHashKey("hei_v_ilev_bk_gate2_pris"), status = 0},
        {x = 252.72, y = 220.95, z = 101.68, he = 160.278, h = GetHashKey("hei_v_ilev_bk_safegate_pris"), status = 0},
        {x = 261.01, y = 215.01, z = 101.68, he = 250.082, h = GetHashKey("hei_v_ilev_bk_safegate_pris"), status = 0},
        {x = 253.92, y = 224.56, z = 101.88, he = 160.000, h = GetHashKey("v_ilev_bk_vaultdoor"), status = 0}
    }

    Config['heist_pacific'].searchlocations = {
        {coords = {x = 233.40, y = 221.53, z = 110.40}, status = false},
        {coords = {x = 240.93, y = 211.12, z = 110.40}, status = false},
        {coords = {x = 246.54, y = 208.86, z = 110.40}, status = false},
        {coords = {x = 264.33, y = 212.16, z = 110.40}, status = false},
        {coords = {x = 252.87, y = 222.36, z = 106.35}, status = false},
        {coords = {x = 249.71, y = 227.84, z = 106.35}, status = false},
        {coords = {x = 244.80, y = 229.70, z = 106.35}, status = false}
    }

    Config['heist_pacific'].checks = {
        hack1 = false,
        hack2 = false,
        thermal1 = false,
        thermal2 = false,
        id1 = false,
        id2 = false,
        idfound = false,
        grab1 = false,
        grab2 = false,
        grab3 = false,
        grab4 = false,
        grab5 = false
    }

    Config['heist_pacific'].searchinfo = {
        random = math.random(1, Config['heist_pacific'].cur),
        found = false
    }

    PacificHeist.program = 0;
    PacificHeist.scaleform = nil;
    PacificHeist.lives = 5;
    PacificHeist.ClickReturn = nil;
    PacificHeist.SorF = false;
    PacificHeist.Hacking = false;
    PacificHeist.UsingComputer = false;
    Wait(1000)
    Config['heist_pacific'].hackfinish = false;
    Config['heist_pacific'].stage0break = false;
    Config['heist_pacific'].stage1break = false;
    Config['heist_pacific'].stage2break = false;
    Config['heist_pacific'].stage4break = false;
    Config['heist_pacific'].initiator = false;
    PacificHeist:HandleInfo()
end)


RegisterNetEvent("heist_pacific:policeDoor_c")
AddEventHandler("heist_pacific:policeDoor_c", function(doornum, status)
    Config['heist_pacific'].PoliceDoors[doornum].locked = status
end)

RegisterNetEvent("heist_pacific:openvault_c")
AddEventHandler("heist_pacific:openvault_c", function(method)
    TriggerEvent("heist_pacific:vault", method)
    TriggerEvent("heist_pacific:vaultsound")
end)

RegisterNetEvent("heist_pacific:vault")
AddEventHandler("heist_pacific:vault", function(method)
	--local obj = Framework.Game.GetClosestObject(Config['heist_pacific'].vault.type, vector3(Config['heist_pacific'].vault.x, Config['heist_pacific'].vault.y, Config['heist_pacific'].vault.z))
	local obj = GetClosestObjectOfType(Config['heist_pacific'].vault.x, Config['heist_pacific'].vault.y, Config['heist_pacific'].vault.z, 2.0, GetHashKey(Config['heist_pacific'].vault.type), false, false, false)
    local count = 0;

    if method == 1 then
        repeat
	        local rotation = GetEntityHeading(obj) - 0.05

            SetEntityHeading(obj, rotation)
            count = count + 1
            Wait(10)
        until count == 1100
    else
        repeat
	        local rotation = GetEntityHeading(obj) + 0.05

            SetEntityHeading(obj, rotation)
            count = count + 1
            Wait(10)
        until count == 1100
    end

    FreezeEntityPosition(obj, true)
end)

RegisterNetEvent("heist_pacific:vaultsound")
AddEventHandler("heist_pacific:vaultsound", function()
    local coords = GetEntityCoords(PlayerPedId())
    local count = 0;

    if GetDistanceBetweenCoords(coords, Config['heist_pacific'].vault.x, Config['heist_pacific'].vault.y, Config['heist_pacific'].vault.z, true) <= 10 then
        repeat
            PlaySoundFrontend(-1, "OPENING", "MP_PROPERTIES_ELEVATOR_DOORS" , 1)
            Wait(900)
            count = count + 1
        until count == 17
    end
end)

RegisterNetEvent('heist_pacific:alarm')
AddEventHandler('heist_pacific:alarm', function(status)
    if status == 1 then
        PacificHeist.PlaySound = true;
    elseif status == 2 then
        PacificHeist.PlaySound = false;
        SendNUIMessage({transactionType = 'stopSound'})
    end
end)

RegisterNetEvent("heist_pacific:updatecheck_c")
AddEventHandler("heist_pacific:updatecheck_c", function(var, status)
    Config['heist_pacific'].checks[var] = status;
end)

RegisterNetEvent("heist_pacific:startloot_c")
AddEventHandler("heist_pacific:startloot_c", function()
    Config['heist_pacific'].startloot = true;
end)

RegisterNetEvent("heist_pacific:vaulttimer")
AddEventHandler("heist_pacific:vaulttimer", function(method)
    if method == 1 then
        Framework.ShowNotification("Vous avez 90 secondes avant l'arrivé d'un gaz toxique.")

        Config['heist_pacific'].starttimer = true;
        Config['heist_pacific'].vaulttime = 90;

        CreateThread(function()
            while true do
                Wait(1)
                if Config['heist_pacific'].starttimer then
                    PacificHeist:ShowVaultTimer()
                elseif not Config['heist_pacific'].starttimer then
                    break
                end
            end
        end)

        repeat
            Wait(1000)
            Config['heist_pacific'].vaulttime = Config['heist_pacific'].vaulttime - 1
        until Config['heist_pacific'].vaulttime == 0

        exports["ac"]:ExecuteServerEvent("heist_pacific:ostimer")
        exports["ac"]:ExecuteServerEvent("heist_pacific:gas")

        CreateThread(function()
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do Wait(10) end

            while true do
                wait = 1000;
                if Config['heist_pacific'].begingas then
                    wait = 1;
                    SetPtfxAssetNextCall("core")
                    Gas = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 262.78, 213.22, 101.68, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                    
                    SetPtfxAssetNextCall("core")
                    Gas2 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 257.71, 216.64, 101.68, 0.0, 0.0, 0.0, 1.50, false, false, false, false)
                    
                    SetPtfxAssetNextCall("core")
                    Gas3 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 252.71, 218.22, 101.68, 0.0, 0.0, 0.0, 1.50, false, false, false, false)
                    
                    Wait(5000)
                    StopParticleFxLooped(Gas, 0)
                    StopParticleFxLooped(Gas2, 0)
                    StopParticleFxLooped(Gas3, 0)
                end
                Wait(wait)
            end
        end)

        Wait(5000)
        Config['heist_pacific'].starttimer = false;
        Wait(30000)
        Config['heist_pacific'].begingas = false;

        exports["ac"]:ExecuteServerEvent("heist_pacific:alarm_s", 2)

        Framework.TriggerServerCallback("heist_pacific:gettotalcash", function(result)
            PacificHeist.text = "$"..Framework.Math.GroupDigits(result)
            Framework.ShowNotification("Vous avez volé "..PacificHeist.text)
        end)
    else
        Framework.ShowNotification("Vous avez 90 secondes avant l'arrivé d'un gaz toxique.")

        Config['heist_pacific'].starttimer = true;
        Config['heist_pacific'].vaulttime = 90;

        CreateThread(function()
            while true do
                Wait(1)
                if Config['heist_pacific'].starttimer then
                    PacificHeist:ShowVaultTimer()
                elseif not Config['heist_pacific'].starttimer then
                    break
                end
            end
        end)

        repeat
            Wait(1000)
            Config['heist_pacific'].vaulttime = Config['heist_pacific'].vaulttime - 1
        until Config['heist_pacific'].vaulttime == 0

        exports["ac"]:ExecuteServerEvent("heist_pacific:ostimer")
        exports["ac"]:ExecuteServerEvent("heist_pacific:gas")

        CreateThread(function()
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do Wait(10) end
            while true do
                wait = 1000;
                if Config['heist_pacific'].begingas then
                    wait = 1;
                    SetPtfxAssetNextCall("core")
                    Gas = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 262.78, 213.22, 101.68, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                    
                    SetPtfxAssetNextCall("core")
                    Gas2 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 257.71, 216.64, 101.68, 0.0, 0.0, 0.0, 1.50, false, false, false, false)
                    
                    SetPtfxAssetNextCall("core")
                    Gas3 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 252.71, 218.22, 101.68, 0.0, 0.0, 0.0, 1.50, false, false, false, false)
                    
                    Wait(5000)
                    StopParticleFxLooped(Gas, 0)
                    StopParticleFxLooped(Gas2, 0)
                    StopParticleFxLooped(Gas3, 0)
                end
                Wait(wait)
            end
        end)

        Wait(5000)
        Config['heist_pacific'].starttimer = false;
        Wait(30000)
        Config['heist_pacific'].begingas = false;

        exports["ac"]:ExecuteServerEvent("heist_pacific:alarm_s", 2)

		Framework.TriggerServerCallback("heist_pacific:gettotalcash", function(result)
            PacificHeist.text = "$"..Framework.Math.GroupDigits(result)
            Framework.ShowNotification("Vous avez volé "..PacificHeist.text)
        end)
    end
end)

RegisterNetEvent("heist_pacific:gas_c")
AddEventHandler("heist_pacific:gas_c", function()
    CreateThread(function()
        Config['heist_pacific'].begingas = true;
        Framework.ShowNotification("La porte va se fermer automatiquement dans 60 secondes.")

        while true do
            wait = 1000;
            if Config['heist_pacific'].begingas then
                wait = 1;
                local playerloc = GetEntityCoords(PlayerPedId())
                local dst1 = GetDistanceBetweenCoords(playerloc, 252.71, 218.22, 101.68, true)
                local dst2 = GetDistanceBetweenCoords(playerloc, 262.78, 213.22, 101.68, true)

                if dst1 <= 5 or dst2 <= 6.5 then
                    ApplyDamageToPed(PlayerPedId(), 3, false)
                    Wait(500)
                end
            end
            Wait(wait)
        end
    end)

    CreateThread(function()
        while true do
            wait = 1000;
            if Config['heist_pacific'].begingas then
                wait = 1;

				Grab2clear = true;
                Grab3clear = true;

                if DoesEntityExist(GrabBag) then DeleteEntity(GrabBag) end

                SetPedComponentVariation(ped, 5, 113, 0, 0)
                NetworkStopSynchronisedScene(Grab1)
                NetworkStopSynchronisedScene(Grab2)
                NetworkStopSynchronisedScene(Grab3)
                Wait(12000)

                for i = 1, #Config['heist_pacific'].obj, 1 do
                    local entity = GetClosestObjectOfType(Config['heist_pacific'].obj[i].x, Config['heist_pacific'].obj[i].y, Config['heist_pacific'].obj[i].z, 1.0, Config['heist_pacific'].obj[i].h, false, false, false)
                    if DoesEntityExist(entity) then DeleteEntity(entity) end
                end

                for j = 1, #Config['heist_pacific'].emptyobjs, 1 do
                    local entity = GetClosestObjectOfType(Config['heist_pacific'].emptyobjs[j].x, Config['heist_pacific'].emptyobjs[j].y, Config['heist_pacific'].emptyobjs[j].z, 1.0, Config['heist_pacific'].emptyobjs[j].h, false, false, false)
                    if DoesEntityExist(entity) then DeleteEntity(entity) end
                end

				Config['heist_pacific'].stagelootbreak = true;
				Wait(48000)
                Config['heist_pacific'].stage2break = true;
                Config['heist_pacific'].stage4break = true;

                Framework.ShowNotification("LA PORTE SE FERME !")

                TriggerEvent("heist_pacific:vault", 2)
                TriggerEvent("heist_pacific:vaultsound")

                for k, v in ipairs(Config['heist_pacific'].doorchecks) do
                    if k == 1 or k == 4 or k == 5 then
                        TriggerEvent("heist_pacific:moltgate_c", v.x, v.y, v.z, v.h1, v.h2, 2)
                    end
                end

                Config['heist_pacific'].begingas = false;

                if Config['heist_pacific'].grabber then
                    Framework.TriggerServerCallback("heist_pacific:gettotalcash", function(result)
                        PacificHeist.text = "$"..Framework.Math.GroupDigits(result)
                        Framework.ShowNotification("Vous avez volé "..PacificHeist.text)
                    end)
                end
                return
            end
            Wait(wait)
        end
    end)
end)
RegisterNetEvent("heist_pacific:policenotify")
AddEventHandler("heist_pacific:policenotify", function(toggle)
    for k,v in pairs(Config['heist_pacific'].PoliceJobs) do
        if Framework.PlayerData.jobs['job'].name == v then
            if toggle == 1 then
                Framework.ShowNotification("BRAQUAGE PACIFIQUE BANQUE !")
                if not DoesBlipExist(Config['heist_pacific'].alarmblip) then
                    Config['heist_pacific'].alarmblip = AddBlipForCoord(Config['heist_pacific'].loudstart.x, Config['heist_pacific'].loudstart.y, Config['heist_pacific'].loudstart.z)
                    SetBlipSprite(Config['heist_pacific'].alarmblip, 161)
                    SetBlipScale(Config['heist_pacific'].alarmblip, 2.0)
                    SetBlipColour(Config['heist_pacific'].alarmblip, 1)
                    PulseBlip(Config['heist_pacific'].alarmblip)
                end
            elseif toggle == 2 then
                if DoesBlipExist(Config['heist_pacific'].alarmblip) then
                    RemoveBlip(Config['heist_pacific'].alarmblip)
                end
            end
        end
    end
end)

--[[RegisterNetEvent("heist_pacific:toggleDoor_c")
AddEventHandler("heist_pacific:toggleDoor_c", function(door, coord, status)
    local obj = Framework.Game.GetClosestObject(door, coord)

    FreezeEntityPosition(obj, status)
end)]]

RegisterNetEvent("heist_pacific:moltgate_c")
AddEventHandler("heist_pacific:moltgate_c", function(x, y, z, oldmodel, newmodel, method)
    if method == 2 then
        CreateModelSwap(x, y, z, 5, GetHashKey(newmodel), GetHashKey(oldmodel), 1)
    else
        CreateModelSwap(x, y, z, 5, GetHashKey(oldmodel), GetHashKey(newmodel), 1)
    end
end)

RegisterNetEvent("heist_pacific:fixdoor_c")
AddEventHandler("heist_pacific:fixdoor_c", function(hash, coords, heading)
    local door = GetClosestObjectOfType(coords, 2.0, hash, false, false, false)

    Wait(250)
    SetEntityHeading(door, heading)
    FreezeEntityPosition(door, true)
end)

RegisterNetEvent("heist_pacific:ptfx_c")
AddEventHandler("heist_pacific:ptfx_c", function(method)
    local ptfx
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do Wait(100) end

    if method == 1 then
        ptfx = vector3(257.39, 221.20, 106.29)
    elseif method == 2 then
        ptfx = vector3(252.985, 221.70, 101.72)
    elseif method == 3 then
        ptfx = vector3(261.68, 216.63, 101.75)
    end

    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Wait(13000)
    StopParticleFxLooped(effect, 0)
end)