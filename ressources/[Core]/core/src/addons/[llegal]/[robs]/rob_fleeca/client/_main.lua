FleecaRob = {}

FleecaRob.Freeze = {F1 = 0, F2 = 0, F3 = 0, F4 = 0, F5 = 0, F6 = 0}
FleecaRob.Check = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
FleecaRob.SearchChecks = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
FleecaRob.LootCheck = {
    F1 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F2 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F3 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F4 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F5 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F6 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false}
}

FleecaRob.Doors = {}

FleecaRob.disableinput = false;
FleecaRob.initiator = false;
FleecaRob.startdstcheck = false;
FleecaRob.currentname = nil;
FleecaRob.currentcoords = nil;
FleecaRob.done = true;
FleecaRob.dooruse = false;

CreateThread(function() 
    while true do 
        wait = 750
        local enabled = false;

        if FleecaRob.disableinput then 
            wait = 1;
            enabled = true;
            FleecaRob:DisableControl() 
        end 

        Wait(wait)
    end
end)

RegisterNetEvent("rob_fleeca:resetDoorState")
AddEventHandler("rob_fleeca:resetDoorState", function(name) FleecaRob.Freeze[name] = 0; end)

RegisterNetEvent("rob_fleeca:lootup_c")
AddEventHandler("rob_fleeca:lootup_c", function(var, var2) FleecaRob.LootCheck[var][var2] = true; end)

RegisterNetEvent("rob_fleeca:outcome")
AddEventHandler("rob_fleeca:outcome", function(oc, arg)
    for i = 1, #FleecaRob.Check, 1 do FleecaRob.Check[i] = false; end

    for i = 1, #FleecaRob.LootCheck, 1 do
        for j = 1, #FleecaRob.LootCheck[i] do FleecaRob.LootCheck[i][j] = false; end
    end

    if oc then
        FleecaRob.Check[arg] = true;
        TriggerEvent("rob_fleeca:startheist", Config['rob_fleeca'].Banks[arg], arg)
    elseif not oc then
        Framework.ShowNotification(arg)
    end
end)

RegisterNetEvent("rob_fleeca:startLoot_c")
AddEventHandler("rob_fleeca:startLoot_c", function(data, name)
    FleecaRob.currentname = name;
    FleecaRob.currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)

    if not FleecaRob.LootCheck[name].Stop then
        CreateThread(function()
            while true do
                wait = 750;

                local plyCoords = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(plyCoords, data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z, true)

                if dist < 40 then
                    wait = 1;

                    if not FleecaRob.LootCheck[name].Loot1 then
                        local dist1 = GetDistanceBetweenCoords(plyCoords, data.trolley1.x, data.trolley1.y, data.trolley1.z + 1, true)

                        if dist1 < 5 then
                            Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voler l'argent")
                            if dist1 < 0.75 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("rob_fleeca:lootup", name, "Loot1")
                                StartGrab(name)
                            end
                        end
                    end

                    if not FleecaRob.LootCheck[name].Loot2 then
                        local dist1 = GetDistanceBetweenCoords(plyCoords, data.trolley2.x, data.trolley2.y, data.trolley2.z+1, true)

                        if dist1 < 5 then
                            Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voler l'argent")
                            if dist1 < 1 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("rob_fleeca:lootup", name, "Loot2")
                                StartGrab(name)
                            end
                        end
                    end

                    if not FleecaRob.LootCheck[name].Loot3 then
                        local dist1 = GetDistanceBetweenCoords(plyCoords, data.trolley3.x, data.trolley3.y, data.trolley3.z+1, true)

                        if dist1 < 5 then
                            Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voler l'argent")
                            if dist1 < 1 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("rob_fleeca:lootup", name, "Loot3")
                                StartGrab(name)
                            end
                        end
                    end

                    if FleecaRob.LootCheck[name].Stop or (FleecaRob.LootCheck[name].Loot1 and FleecaRob.LootCheck[name].Loot2 and FleecaRob.LootCheck[name].Loot3) then
                        FleecaRob.LootCheck[name].Stop = false;
                        if FleecaRob.initiator then
                            TriggerEvent("rob_fleeca:reset", name, data)
                            return
                        end

                        return
                    end
                end

                Wait(wait)
            end
        end)
    end
end)

RegisterNetEvent("rob_fleeca:stopHeist_c")
AddEventHandler("rob_fleeca:stopHeist_c", function(name) FleecaRob.LootCheck[name].Stop = true; end)

RegisterNetEvent("rob_fleeca:policenotify")
AddEventHandler("rob_fleeca:policenotify", function(name)
    local blip = nil;

    while Framework.PlayerData.jobs == nil do Wait(1) end

    for k,v in pairs(Config['rob_fleeca'].PoliceJobs) do
        if Framework.PlayerData.jobs['job'].name == v then
            Framework.ShowAdvancedNotification('BRAQUAGE', 'FLEECA BANK', 'UN BRAQUAGE EST EN COURS A LA FLEECA BANK, REGARDER VOTRE GPS !!', 'CHAR_ARTHUR', 8, true, true, 130)
        
            if not DoesBlipExist(blip) then
                blip = AddBlipForCoord(Config['rob_fleeca'].Banks[name].doors.startloc.x, Config['rob_fleeca'].Banks[name].doors.startloc.y, Config['rob_fleeca'].Banks[name].doors.startloc.z)
                SetBlipSprite(blip, 161)
                SetBlipScale(blip, 2.0)
                SetBlipColour(blip, 1)
    
                PulseBlip(blip)
                Wait(240000)
                RemoveBlip(blip)
            end
        end
    end
end)

-- MAIN DOOR UPDATE --

AddEventHandler("rob_fleeca:freezeDoors", function()
    CreateThread(function()
        while true do
            wait = 2500;

            for k, v in pairs(FleecaRob.Doors) do
                local myCoords = GetEntityCoords(PlayerPedId())
                local objCoords = GetEntityCoords(v[1].obj)
                local dist = Vdist(myCoords, objCoords)

                if dist < 10.0 then
                    wait = 1;
                    
                    if v[1].obj == nil or not DoesEntityExist(v[1].obj) then
                        v[1].obj = GetClosestObjectOfType(v[1].loc, 1.5, GetHashKey("v_ilev_gb_vaubar"), false, false, false)
                        FreezeEntityPosition(v[1].obj, v[1].locked)
                    else
                        FreezeEntityPosition(v[1].obj, v[1].locked)
                        Wait(100)
                    end
                    if v[1].locked then
                        SetEntityHeading(v[1].obj, v[1].h)
                    end
                end
            end

            Wait(wait)
        end
    end)

    CreateThread(function()
        while true do
            wait = 2500;

            for k,v in pairs(Config['rob_fleeca'].PoliceJobs) do
                if Framework.PlayerData.jobs['job'].name == v and not FleecaRob.dooruse then
                    wait = 500;
                    local pcoords = GetEntityCoords(PlayerPedId())

                    for k, v in pairs(FleecaRob.Doors) do
                        for i = 1, 2, 1 do
                            local dist = GetDistanceBetweenCoords(pcoords, v[i].loc, true)
    
                            if dist <= 4.0 then
                                wait = 1;

                                if v[i].locked then
                                    Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour déverrouiller la porte")
                                elseif not v[i].locked then
                                    Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour verrouiller la porte")
                                end

                                if dist <= 1 and IsControlJustReleased(0, 38) then
                                    FleecaRob.dooruse = true;

                                    if i == 2 then
                                        TriggerServerEvent("rob_fleeca:toggleVault", k, not v[i].locked)
                                    else
                                        TriggerServerEvent("rob_fleeca:toggleDoor", k, not v[i].locked)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            Wait(wait)
        end
    end)

    CreateThread(function()
        function FleecaRob:doVaultStuff()
            while true do
                wait = 750;
                
                local pcoords = GetEntityCoords(PlayerPedId())

                for k, v in pairs(FleecaRob.Doors) do
                    local dist = GetDistanceBetweenCoords(v[2].loc, pcoords, true)
    
                    if dist < 20.0 then
                        wait = 1;
                        if v[2].state ~= nil then
                            local obj
                            if k ~= "F4" then
                                obj = GetClosestObjectOfType(v[2].loc, 1.5, GetHashKey("v_ilev_gb_vauldr"), false, false, false)
                            else
                                obj = GetClosestObjectOfType(v[2].loc, 1.5, 4231427725, false, false, false)
                            end
                            SetEntityHeading(obj, v[2].state)
                            Wait(1000)
                            return FleecaRob:doVaultStuff()
                        end
                    end
                end

                Wait(wait)
            end
        end

        FleecaRob:doVaultStuff()
    end)
end)

RegisterNetEvent("rob_fleeca:toggleDoor")
AddEventHandler("rob_fleeca:toggleDoor", function(key, state)
    FleecaRob.Doors[key][1].locked = state;
    FleecaRob.dooruse = false;
end)

RegisterNetEvent("rob_fleeca:toggleVault")
AddEventHandler("rob_fleeca:toggleVault", function(key, state)
    FleecaRob.dooruse = true;
    FleecaRob.Doors[key][2].state = nil;

    if Config['rob_fleeca'].Banks[key].hash == nil then
        if not state then
            local obj = GetClosestObjectOfType(Config['rob_fleeca'].Banks[key].doors.startloc.x, Config['rob_fleeca'].Banks[key].doors.startloc.y, Config['rob_fleeca'].Banks[key].doors.startloc.z, 2.0, GetHashKey(Config['rob_fleeca'].vaultdoor), false, false, false)
            local count = 0;

            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Wait(10)
            until count == 900

            FleecaRob.Doors[key][2].locked = state;
            FleecaRob.Doors[key][2].state = GetEntityHeading(obj)

            TriggerServerEvent("rob_fleeca:updateVaultState", key, FleecaRob.Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(Config['rob_fleeca'].Banks[key].doors.startloc.x, Config['rob_fleeca'].Banks[key].doors.startloc.y, Config['rob_fleeca'].Banks[key].doors.startloc.z, 2.0, GetHashKey(Config['rob_fleeca'].vaultdoor), false, false, false)
            local count = 0;

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Wait(10)
            until count == 900

            FleecaRob.Doors[key][2].locked = state;
            FleecaRob.Doors[key][2].state = GetEntityHeading(obj)

            TriggerServerEvent("rob_fleeca:updateVaultState", key, FleecaRob.Doors[key][2].state)
        end
    else
        if not state then
            local obj = GetClosestObjectOfType(Config['rob_fleeca'].Banks.F4.doors.startloc.x, Config['rob_fleeca'].Banks.F4.doors.startloc.y, Config['rob_fleeca'].Banks.F4.doors.startloc.z, 2.0, Config['rob_fleeca'].Banks.F4.hash, false, false, false)
            local count = 0;

            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Wait(10)
            until count == 900

            FleecaRob.Doors[key][2].locked = state;
            FleecaRob.Doors[key][2].state = GetEntityHeading(obj)

            TriggerServerEvent("rob_fleeca:updateVaultState", key, FleecaRob.Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(Config['rob_fleeca'].Banks.F4.doors.startloc.x, Config['rob_fleeca'].Banks.F4.doors.startloc.y, Config['rob_fleeca'].Banks.F4.doors.startloc.z, 2.0, Config['rob_fleeca'].Banks.F4.hash, false, false, false)
            local count = 0;

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Wait(10)
            until count == 900

            FleecaRob.Doors[key][2].locked = state;
            FleecaRob.Doors[key][2].state = GetEntityHeading(obj)

            TriggerServerEvent("rob_fleeca:updateVaultState", key, FleecaRob.Doors[key][2].state)
        end
    end

    FleecaRob.dooruse = false;
end)

AddEventHandler("rob_fleeca:reset", function(name, data)
    for i = 1, #FleecaRob.LootCheck[name], 1 do FleecaRob.LootCheck[name][i] = false; end
    FleecaRob.Check[name] = false;
    Framework.ShowNotification("LA PORTE DU COFFRE SE FERMERA DANS 30 SECONDES !")
    Wait(30000)
    Framework.ShowNotification("FERMETURE DE LA PORTE DU COFFRE-FORT !")
    TriggerServerEvent("rob_fleeca:toggleVault", name, true)
    TriggerEvent("rob_fleeca:cleanUp", data, name)
end)

AddEventHandler("rob_fleeca:startheist", function(data, name)
    TriggerServerEvent("rob_fleeca:toggleDoor", name, true) -- ensure to lock the second door for the second, third, fourth... heist
   
    FleecaRob.disableinput = true;
    FleecaRob.currentname = name;
    FleecaRob.currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    FleecaRob.initiator = true;

    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do Wait(1) end
    
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.startloc.animcoords.x, data.doors.startloc.animcoords.y, data.doors.startloc.animcoords.z)
    SetEntityHeading(ped, data.doors.startloc.animcoords.h)
    local pedco = GetEntityCoords(PlayerPedId())
    IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    ProgressBars:startUI(2000, "Utilisation de la ~r~Carte d'accès malveillante")
    Wait(1500)
    DetachEntity(IdProp, false, false)
    SetEntityCoords(IdProp, data.prop.first.coords, 0.0, 0.0, 0.0, false)
    SetEntityRotation(IdProp, data.prop.first.rot, 1, true)
    FreezeEntityPosition(IdProp, true)
    Wait(500)
    ClearPedTasksImmediately(ped)
    FleecaRob.disableinput = false;
    Wait(1000)
    Process(Config['rob_fleeca'].hacktime, "Piratage en cours")
    Framework.ShowNotification("Piratage Terminé !")
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerServerEvent("rob_fleeca:toggleVault", name, false)
    FleecaRob.startdstcheck = true;
    FleecaRob.currentname = name;
    Framework.ShowNotification("Vous avez 2 minutes jusqu'à l'activation du système de sécurité.")
    SpawnTrolleys(data, name)
end)

AddEventHandler("rob_fleeca:cleanUp", function(data, name)
    Wait(10000)
    for i = 1, 3, 1 do -- full trolley clean
        local obj = GetClosestObjectOfType(data.objects[i].x, data.objects[i].y, data.objects[i].z, 0.75, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)

        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    for j = 1, 3, 1 do -- empty trolley clean
        local obj = GetClosestObjectOfType(data.objects[j].x, data.objects[j].y, data.objects[j].z, 0.75, GetHashKey("hei_prop_hei_cash_trolly_03"), false, false, false)

        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    if DoesEntityExist(IdProp) then DeleteEntity(IdProp) end
    if DoesEntityExist(IdProp2) then DeleteEntity(IdProp2) end
    TriggerServerEvent("rob_fleeca:setCooldown", name)
    FleecaRob.initiator = false;
end)

function SecondDoor(data, key)
    FleecaRob.disableinput = true;
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do Wait(10) end
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.secondloc.animcoords.x, data.doors.secondloc.animcoords.y, data.doors.secondloc.animcoords.z)
    SetEntityHeading(ped, data.doors.secondloc.animcoords.h)
    local pedco = GetEntityCoords(PlayerPedId())
    IdProp2 = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp2, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    ProgressBars:startUI(2000, "Utilisation d'une carte malveillante")
    Wait(1500)
    DetachEntity(IdProp2, false, false)
    SetEntityCoords(IdProp2, data.prop.second.coords, 0.0, 0.0, 0.0, false)
    SetEntityRotation(IdProp2, data.prop.second.rot, 1, true)
    FreezeEntityPosition(IdProp2, true)
    Wait(1000)
    ClearPedTasksImmediately(ped)
    FleecaRob.disableinput = false;
    Process(2000, "Accéder au panneau")
    Framework.ShowNotification("Accès terminé!")
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    --TriggerServerEvent("rob_fleeca:openDoor", vector3(data.doors.secondloc.x, data.doors.secondloc.y, data.doors.secondloc.z), 3)
    TriggerServerEvent("rob_fleeca:toggleDoor", key, false)
    FleecaRob.disableinput = false;
end

function Process(ms, text)
    ProgressBars:startUI(ms, text)
    Wait(ms)
end

function SpawnTrolleys(data, name)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do Wait(10) end
    Trolley1 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley1.x, data.trolley1.y, data.trolley1.z, 1, 1, 0)
    Trolley2 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley2.x, data.trolley2.y, data.trolley2.z, 1, 1, 0)
    Trolley3 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley3.x, data.trolley3.y, data.trolley3.z, 1, 1, 0)
    local h1 = GetEntityHeading(Trolley1)
    local h2 = GetEntityHeading(Trolley2)
    local h3 = GetEntityHeading(Trolley3)

    SetEntityHeading(Trolley1, h1 + Config['rob_fleeca'].Banks[name].trolley1.h)
    SetEntityHeading(Trolley2, h2 + Config['rob_fleeca'].Banks[name].trolley2.h)
    SetEntityHeading(Trolley3, h3 + Config['rob_fleeca'].Banks[name].trolley3.h)
    local players, nearbyPlayer = Framework.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 20.0)
    local missionplayers = {}

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            table.insert(missionplayers, GetPlayerServerId(players[i]))
        end
    end
    TriggerServerEvent("rob_fleeca:startLoot", data, name, missionplayers)
    FleecaRob.done = false;
end

function StartGrab(name)
    FleecaRob.disableinput = true;
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
				    if not IsEntityVisible(grabobj) then SetEntityVisible(grabobj, true, false) end
			    end
			    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        exports["ac"]:ExecuteServerEvent('rob_fleeca:rewardCash')
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley;
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    --TriggerServerEvent("rob_fleeca:updateObj", name, NewTrolley, 2)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
	Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 113, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    FleecaRob.disableinput = false;
end

CreateThread(function()
    while true do
        wait = 750;

        if FleecaRob.startdstcheck then
            if FleecaRob.initiator then
                local playercoord = GetEntityCoords(PlayerPedId())

                if (GetDistanceBetweenCoords(playercoord, FleecaRob.currentcoords, true)) > 20 then
                    wait = 1;

                    FleecaRob.LootCheck[FleecaRob.currentname].Stop = true;
                    FleecaRob.startdstcheck = false;
                    TriggerServerEvent("rob_fleeca:stopHeist", FleecaRob.currentname)
                end
            end
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        wait = 750;

        if not FleecaRob.done then
            local pedcoords = GetEntityCoords(PlayerPedId())
            local dst = GetDistanceBetweenCoords(pedcoords, Config['rob_fleeca'].Banks[FleecaRob.currentname].doors.secondloc.x, Config['rob_fleeca'].Banks[FleecaRob.currentname].doors.secondloc.y, Config['rob_fleeca'].Banks[FleecaRob.currentname].doors.secondloc.z, true)

            if dst < 4 then
                wait = 1;
                Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour utiliser la Carte de Sécurité")
                if dst < 0.75 and IsControlJustReleased(0 , 38) then
                    Framework.TriggerServerCallback("rob_fleeca:checkSecond", function(result)
                        if result then
                            FleecaRob.done = true;
                            return SecondDoor(Config['rob_fleeca'].Banks[FleecaRob.currentname], FleecaRob.currentname)
                        elseif not result then
                            Framework.ShowNotification("Vous n'avez pas de ~r~Carte de Sécurité Fleeca Bank.")
                        end
                    end)
                end
            end
            if FleecaRob.LootCheck[FleecaRob.currentname].Stop then
                FleecaRob.done = true;
            end
        end

        Wait(wait)
    end
end)

CreateThread(function()
    local resettimer = Config['rob_fleeca'].timer

    while true do
        wait = 750;

        if FleecaRob.startdstcheck then
            wait = 1;

            if FleecaRob.initiator then
                if Config['rob_fleeca'].timer > 0 then
                    Wait(1000)
                    Config['rob_fleeca'].timer = Config['rob_fleeca'].timer - 1
                elseif Config['rob_fleeca'].timer == 0 then
                    FleecaRob.startdstcheck = false;
                    TriggerServerEvent("rob_fleeca:stopHeist", FleecaRob.currentname)
                    Config['rob_fleeca'].timer = resettimer
                end
            end
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        wait = 750;

        if FleecaRob.startdstcheck then
            if FleecaRob.initiator then
                wait = 1;
                FleecaRob:ShowTimer()
            end
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while Framework.PlayerData == nil do Wait(100) end
    while Framework.PlayerData.jobs == nil do Wait(100) end

    Framework.TriggerServerCallback("rob_fleeca:getBanks", function(bank, door)
        Config['rob_fleeca'].Banks = bank
        FleecaRob.Doors = door
    end)
    --Wait(1000)
    TriggerEvent("rob_fleeca:freezeDoors")
    while true do
        wait = 750;

        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name ~= "police" and Framework.PlayerData.jobs['job'].name ~= "sheriff" then
            local coords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(Config['rob_fleeca'].Banks) do
                if not v.onaction then
                    local dst = GetDistanceBetweenCoords(coords, v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z, true)
                    --local dst2 = GetDistanceBetweenCoords(coords, v.doors.lockpick.x, v.doors.lockpick.y, v.doors.lockpick.z, true)

                    if dst <= 5 and not FleecaRob.Check[k] then
                        wait = 1;

                        Framework.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour démarrer le Braquage de Banque")
                        if dst <= 1 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent("rob_fleeca:startcheck", k)
                        end
                    end
                end
            end
        end

        Wait(wait)
    end
end)


CreateThread(function()

    for k,v in pairs(Config['rob_fleeca'].Banks) do 
        local blip = AddBlipForCoord(v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z)
        SetBlipSprite(blip, 134)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Braquage de banque")
        EndTextCommandSetBlipName(blip)
    end
end)