
Garages.Indexs = {
    action = 1
}

Garages.Main = RageUI.CreateMenu("Garages", "Sortir un véhicule", 8, 200)

local open = false

Garages.Main.Closed = function()
    open = false
end

Garages.OpenCarMenu = function(spawn, heading)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Garages.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Garages.Main, true)
        open = true

        Framework.TriggerServerCallback('garages:getOwneds', function(myCars) 
            Garages.ownedCars = myCars
        end, 'car')
        
        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Garages.Main, true, true, true, function()

                    RageUI.Separator("↓   ~p~Dans le garage~s~   ↓")

                    for k,v in pairs(Garages.ownedCars) do
                        if v.state then
                            if v.label ~= nil then
                                RageUI.List("[~b~"..v.plate.."~s~] - "..v.label, { "Sortir", "Renommer" }, Garages.Indexs.action, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            Wait(500)
                                            if Framework.Game.IsSpawnPointClear(spawn, 4.5) then
                                                Framework.Game.SpawnVehicle(v.vehicle.model, spawn, heading, function(vehicle)
                                                    Framework.Game.SetVehicleProperties(vehicle, v.vehicle)
                                                    SetVehRadioStation(vehicle, 'OFF')
                                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        
                                                    exports["ac"]:ExecuteServerEvent("garages:updateState", v, false)
        
                                                    v.state = false
        
                                                    RageUI.CloseAll()
                                                end)
                                                -- TODO Framework.TriggerServerCallback("framework:Onesync:SpawnVehicle", function(vehicle, networkId)
                                                --     if vehicle and networkId then
                                                --         TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                                --         local veh = NetworkGetEntityFromNetworkId(networkId)
                                                --         TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                                --         SetVehRadioStation(vehicle, 'OFF')
                                                --         for _ = 1, 20 do
                                                --             Wait(1)
                                                --             SetPedIntoVehicle(PlayerPedId(), veh, -1)
                                            
                                                --             if GetVehiclePedIsIn(PlayerPedId(), false) == veh then break end
                                                --         end
                                                --         exports["ac"]:ExecuteServerEvent('garages:updateState', v, false)
            
                                                --         v.state = false
            
                                                --         RageUI.CloseAll()
                                                --     end
                                                -- end, v.vehicle.model, vector3(g_posSpawn.x, g_posSpawn.y, g_posSpawn.z+1.0), 0.0, v.vehicle)
                                            else
                                                Framework.ShowNotification("~r~Il n'y a pas asser de place !")
                                            end
                                        elseif Index == 2 then
                                            local name = VisualManager:KeyboardOutput("Nouveau Nom", "", 25)
            
                                            if tostring(name) and name ~= '' then
                                                v.label = name
                                                exports["ac"]:ExecuteServerEvent('garages:renameVehicle', v, name)
                                            else
                                                Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                            end
                                        end
                                    end
                                end, function(Index)
                                    Garages.Indexs.action = Index
                                end)
                            else
                                RageUI.List("[~b~"..v.plate.."~s~] - Non Défini", { "Sortir", "Renommer" }, Garages.Indexs.action, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            Wait(500)
                                            if Framework.Game.IsSpawnPointClear(spawn, 4.5) then
                                                Framework.Game.SpawnVehicle(v.vehicle.model, spawn, heading, function(vehicle)
                                                    Framework.Game.SetVehicleProperties(vehicle, v.vehicle)
                                                    SetVehRadioStation(vehicle, 'OFF')
                                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        
                                                    exports["ac"]:ExecuteServerEvent("garages:updateState", v, false)
        
                                                    v.state = false
        
                                                    RageUI.CloseAll()
                                                end)
                                                -- TODO Framework.TriggerServerCallback("framework:Onesync:SpawnVehicle", function(networkId)
                                                --     if networkId then
                                                --         local vehicle = NetworkGetEntityFromNetworkId(networkId)
                                                --         SetVehRadioStation(vehicle, 'OFF')
                                                --         TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            
                                                --         exports["ac"]:ExecuteServerEvent('garages:updateState', v, false)
            
                                                --         v.state = false
            
                                                --         RageUI.CloseAll()
                                                --     end
                                                -- end, v.vehicle.model, vector3(g_posSpawn.x, g_posSpawn.y, g_posSpawn.z+1.0), 0.0, v.vehicle)
                                            else
                                                Framework.ShowNotification("~r~Il n'y a pas asser de place !")
                                            end
                                        elseif Index == 2 then
                                            local name = VisualManager:KeyboardOutput("Nouveau Nom", "", 25)
            
                                            if name ~= nil and tostring(name) and name ~= '' then
                                                v.label = name
                                                exports["ac"]:ExecuteServerEvent('garages:renameVehicle', v, name)
                                            else
                                                Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                            end
                                        end
                                    end
                                end, function(Index)
                                    Garages.Indexs.action = Index
                                end)
                            end
                        end
                    end

                    RageUI.Separator("↓   ~p~Sorties~s~   ↓")

                    for k,v in pairs(Garages.ownedCars) do
                        if not v.state then
                            RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..v.label, nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        end
                    end

                end)
            end
        end)
    end
end

Garages.OpenBoatMenu = function(spawn, heading)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Garages.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Garages.Main, true)
        open = true

        Framework.TriggerServerCallback("garages:getOwneds", function(myBoats) 
            Garages.ownedBoats = myBoats
        end, 'boat')
        
        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Garages.Main, true, true, true, function()

                    RageUI.Separator("↓   ~p~Dans le garage~s~   ↓")

                    for k,v in pairs(Garages.ownedBoats) do
                        if v.state then
                            RageUI.List("[~b~"..v.plate.."~s~] - "..v.label, { "Sortir", "Renommer" }, Garages.Indexs.action, nil, {}, true, function(Hovered, Active, Selected, Index)
                                if Selected then
                                    if Index == 1 then
                                        Framework.Game.SpawnVehicle(v.vehicle.model, spawn, heading, function(vehicle)
                                            Framework.Game.SetVehicleProperties(vehicle, v.vehicle)
                                            SetVehRadioStation(vehicle, 'OFF')
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

                                            exports["ac"]:ExecuteServerEvent('garages:updateState', v, false)

                                            v.state = false

                                            RageUI.CloseAll()
                                        end)
                                    elseif Index == 2 then
                                        local name = VisualManager:KeyboardOutput("Nouveau Nom", "", 25)
        
                                        if tostring(name) and name ~= '' then
                                            v.label = name
                                            exports["ac"]:ExecuteServerEvent('garages:renameVehicle', v, name)
                                        else
                                            Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                        end
                                    end
                                end
                            end, function(Index)
                                Garages.Indexs.action = Index
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Sorties~s~   ↓")

                    for k,v in pairs(Garages.ownedBoats) do
                        if not v.state then
                            RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..v.label, nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        end
                    end

                end)
            end
        end)
    end
end

Garages.OpenAircraftMenu = function(spawn, heading)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Garages.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Garages.Main, true)
        open = true

        Framework.TriggerServerCallback("garages:getOwneds", function(myAircrafts) 
            Garages.ownedAircrafts = myAircrafts
        end, 'aircraft')
        
        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Garages.Main, true, true, true, function()

                    RageUI.Separator("↓   ~p~Dans le garage~s~   ↓")

                    for k,v in pairs(Garages.ownedAircrafts) do
                        if v.state then
                            RageUI.List("[~b~"..v.plate.."~s~] - "..v.label, { "Sortir", "Renommer" }, Garages.Indexs.action, nil, {}, true, function(Hovered, Active, Selected, Index)
                                if Selected then
                                    if Index == 1 then
                                        Framework.Game.SpawnVehicle(v.vehicle.model, spawn, 0.0, function(vehicle)
                                            Framework.Game.SetVehicleProperties(vehicle, v.vehicle)
                                            SetVehRadioStation(vehicle, 'OFF')
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

                                            exports["ac"]:ExecuteServerEvent('garages:updateState', v, false)

                                            v.state = false

                                            RageUI.CloseAll()
                                        end)
                                    elseif Index == 2 then
                                        local name = VisualManager:KeyboardOutput("Nouveau Nom", "", 25)
        
                                        if tostring(name) and name ~= '' then
                                            v.label = name
                                            exports["ac"]:ExecuteServerEvent('garages:renameVehicle', v, name)
                                        else
                                            Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                        end
                                    end
                                end
                            end, function(Index)
                                Garages.Indexs.action = Index
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Sorties~s~   ↓")

                    for k,v in pairs(Garages.ownedAircrafts) do
                        if not v.state then
                            RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..v.label, nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        end
                    end

                end)
            end
        end)
    end
end