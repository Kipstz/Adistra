
Rob_Shop = {}

Rob_Shop.peds = {}
Rob_Shop.objects = {}

RegisterNetEvent('rob_shop:msgPolice')
AddEventHandler('rob_shop:msgPolice', function(store, robber)
    while Framework.PlayerData.jobs == nil do Wait(100) end

    for k,v in pairs(Config['rob_shops'].PoliceJobs) do
        if Framework.PlayerData.jobs['job'].name == v then
            local mugshot, mugshotStr = Framework.Game.GetPedMugshot(GetPlayerPed(GetPlayerFromServerId(robber)))
            Framework.ShowAdvancedNotification(Config['rob_shops'].Shops[store].name, "Vol en cours", "Nous avons envoyé une photo du voleur prise par la caméra CCTV!", mugshotStr, 4)
            
            UnregisterPedheadshot(mugshot)
        
            while true do
                local name = GetCurrentResourceName() .. math.random(999)
        
                AddTextEntry(name, "~INPUT_CONTEXT~ Définir un point de cheminement vers le magasin \n~INPUT_FRONTEND_RRIGHT~ Fermer cette case")
                DisplayHelpTextThisFrame(name, false)
                
                if IsControlPressed(0, 38) then
                    SetNewWaypoint(Config['rob_shops'].Shops[store].coords.x, Config['rob_shops'].Shops[store].coords.y)
        
                    return
                elseif IsControlPressed(0, 194) then
                    return
                end
        
                Wait(1)
            end
        end
    end
end)

RegisterNetEvent('rob_shop:removePickup')
AddEventHandler('rob_shop:removePickup', function(bank)
    for i = 1, #Rob_Shop.objects do 
        if Rob_Shop.objects[i].bank == bank and DoesEntityExist(Rob_Shop.objects[i].object) then 
            DeleteObject(Rob_Shop.objects[i].object) 
        end 
    end
end)

RegisterNetEvent('rob_shop:robberyOver')
AddEventHandler('rob_shop:robberyOver', function()
    Rob_Shop.inRob = false;
end)

RegisterNetEvent('rob_shop:rob')
AddEventHandler('rob_shop:rob', function(i)
    if not IsPedDeadOrDying(Rob_Shop.peds[i]) then
        SetEntityCoords(Rob_Shop.peds[i], Config['rob_shops'].Shops[i].coords)

        RequestAnimDict('mp_am_hold_up')
        while not HasAnimDictLoaded('mp_am_hold_up') do Wait(1) end
        TaskPlayAnim(Rob_Shop.peds[i], "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)

        while not IsEntityPlayingAnim(Rob_Shop.peds[i], "mp_am_hold_up", "holdup_victim_20s", 3) do Wait(1) end

        local timer = GetGameTimer() + 10800
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(Rob_Shop.peds[i]) then break end
            Wait(1)
        end

        if not IsPedDeadOrDying(Rob_Shop.peds[i]) then
            local cashRegister = GetClosestObjectOfType(GetEntityCoords(Rob_Shop.peds[i]), 5.0, GetHashKey('prop_till_01'))
            if DoesEntityExist(cashRegister) then
                CreateModelSwap(GetEntityCoords(cashRegister), 0.5, GetHashKey('prop_till_01'), GetHashKey('prop_till_01_dam'), false)
            end

            timer = GetGameTimer() + 200 
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(Rob_Shop.peds[i]) then break end
                Wait(1)
            end

            local model = GetHashKey('prop_poly_bag_01')
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(1) end

            local bag = CreateObject(model, GetEntityCoords(Rob_Shop.peds[i]), false, false)
                        
            AttachEntityToEntity(bag, Rob_Shop.peds[i], GetPedBoneIndex(Rob_Shop.peds[i], 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
            
            timer = GetGameTimer() + 10000
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(Rob_Shop.peds[i]) then break end
                Wait(1)
            end

            if not IsPedDeadOrDying(Rob_Shop.peds[i]) then
                DetachEntity(bag, true, false)

                timer = GetGameTimer() + 75

                while timer >= GetGameTimer() do
                    if IsPedDeadOrDying(Rob_Shop.peds[i]) then break end
                    Wait(1)
                end

                SetEntityHeading(bag, Config['rob_shops'].Shops[i].heading)
                ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)

                table.insert(Rob_Shop.objects, {bank = i, object = bag})

                CreateThread(function()
                    while true do
                        Wait(5)

                        if DoesEntityExist(bag) then
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(bag), true) <= 1.5 then
                                PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                                exports["ac"]:ExecuteServerEvent('rob_shop:pickUp', i)
                                break
                            end
                        else
                            break
                        end
                    end
                end)
            else
                DeleteObject(bag)
            end
        end

        RequestAnimDict('mp_am_hold_up')
        while not HasAnimDictLoaded('mp_am_hold_up') do Wait(100) end
        TaskPlayAnim(Rob_Shop.peds[i], "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)

        timer = GetGameTimer() + 2500

        while timer >= GetGameTimer() do Wait(1) end

        TaskPlayAnim(Rob_Shop.peds[i], "mp_am_hold_up", "cower_loop", 8.0, -8.0, -1, 1, 0, false, false, false)

        local stop = GetGameTimer() + 120000
        while stop >= GetGameTimer() do Wait(50) end

        if IsEntityPlayingAnim(Rob_Shop.peds[i], "mp_am_hold_up", "cower_loop", 3) then
            ClearPedTasks(Rob_Shop.peds[i])
        end
    end
end)


RegisterNetEvent('rob_shop:resetStore')
AddEventHandler('rob_shop:resetStore', function(i)
    if DoesEntityExist(Rob_Shop.peds[i]) then DeletePed(Rob_Shop.peds[i]) end

    Wait(250)

    -- Rob_Shop.peds[i] = _CreatePed(Config['rob_shops'].Shopkeeper, Config['rob_shops'].Shops[i].coords, Config['rob_shops'].Shops[i].heading)

    local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(Rob_Shop.peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
    if DoesEntityExist(brokenCashRegister) then
        CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
    end
end)

CreateThread(function()
    for k,v in pairs(Config['rob_shops'].Shops) do 
        Rob_Shop.peds[k] = Rob_Shop:createPed(Config['rob_shops'].Shopkeeper, v.coords, v.heading)

        if v.blip then
            local blip = AddBlipForCoord(v.coords)

            SetBlipSprite(blip, 110)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 0.5)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(blip)
        end

        local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(Rob_Shop.peds[k]), 5.0, GetHashKey('prop_till_01_dam'))

        if DoesEntityExist(brokenCashRegister) then
            CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
        end
    end

    while true do
        wait = 2500;

        local plyID = PlayerId()
        local plyPed = PlayerPedId()

        if IsPedArmed(plyPed, 4) then
            if IsPlayerFreeAiming(plyID) then
                for k,v in pairs(Rob_Shop.peds) do
                    if HasEntityClearLosToEntityInFront(plyPed, v, 19) and not IsPedDeadOrDying(v) and Vdist(GetEntityCoords(plyPed), GetEntityCoords(v)) <= 5.0 then
                        if not Rob_Shop.inRob then
                            wait = 1;

                            Rob_Shop.canRob = nil

                            Framework.TriggerServerCallback('rob_shop:canRob', function(cb)
                                Rob_Shop.canRob = cb
                            end, k)

                            Wait(2000)

                            if Rob_Shop.canRob and Rob_Shop.canRob ~= nil and Rob_Shop.canRob ~= 'no_cops' then
                                Rob_Shop.inRob = true;

                                CreateThread(function()
                                    while Rob_Shop.inRob do 
                                        Wait(1) 

                                        if IsPedDeadOrDying(v) then Rob_Shop.inRob = false ; end 
                                    end
                                end)

                                RequestAnimDict('missheist_agency2ahands_up')

                                while not HasAnimDictLoaded('missheist_agency2ahands_up') do Wait(100) end
                                TaskPlayAnim(v, "missheist_agency2ahands_up", "handsup_anxious", 8.0, -8.0, -1, 1, 0, false, false, false)

                                Rob_Shop.scared = 0

                                while Rob_Shop.scared < 100 and not IsPedDeadOrDying(v) and Vdist(GetEntityCoords(plyPed), GetEntityCoords(v)) <= 7.5 do
                                    local sleep = 600;

                                    SetEntityAnimSpeed(v, "missheist_agency2ahands_up", "handsup_anxious", 1.0)

                                    if IsPlayerFreeAiming(plyID) then
                                        sleep = 250;
                                        SetEntityAnimSpeed(v, "missheist_agency2ahands_up", "handsup_anxious", 1.3)
                                    end

                                    if IsPedArmed(plyPed, 4) and GetAmmoInClip(plyPed, GetSelectedPedWeapon(plyPed)) > 0 and IsControlPressed(0, 24) then
                                        sleep = 50;
                                        SetEntityAnimSpeed(v, "missheist_agency2ahands_up", "handsup_anxious", 1.7)
                                    end

                                    sleep = GetGameTimer() + sleep

                                    while sleep >= GetGameTimer() and not IsPedDeadOrDying(v) do
                                        Wait(1)

                                        DrawRect(0.5, 0.5, 0.2, 0.03, 75, 75, 75, 200)
                                        local draw = Rob_Shop.scared/500
                                        DrawRect(0.5, 0.5, draw, 0.03, 0, 221, 255, 200)
                                    end

                                    Rob_Shop.scared = Rob_Shop.scared + 1
                                end

                                if Vdist(GetEntityCoords(plyPed), GetEntityCoords(v), true) <= 7.5 then
                                    if not IsPedDeadOrDying(v) then
                                        TriggerServerEvent('rob_shop:rob', k)
                                        while Rob_Shop.inRob do Wait(1) if IsPedDeadOrDying(v) then Rob_Shop.inRob = false end end
                                    end
                                else
                                    ClearPedTasks(v)
                                    local timer = GetGameTimer()+5000
                                    while timer >= GetGameTimer() do
                                        Wait(1)

                                        Framework.ShowNotification("Vous êtes partie trop loin !")
                                    end

                                    Rob_Shop.inRob = false;
                                end
                            elseif Rob_Shop.canRob == 'no_cops' then
                                local timer = GetGameTimer()+5000

                                while timer >= GetGameTimer() do
                                    Wait(1)
                                    Framework.ShowNotification("Il n'y a pas assez de policiers en ville !")
                                end
                            elseif not Rob_Shop.canRob then
                                Rob_Shop.inRob = false;

                                local timer = GetGameTimer()+5000

                                while timer >= GetGameTimer() do
                                    Wait(1)
                                    Framework.ShowNotification("Le magasin est fermé il n'y a rien à voler !")
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