
Concess.ConcessMenu = RageUI.CreateMenu(Config['concess'].MenuTitle.MainMenu, Config['concess'].MenuSubTitle.MainMenu, 8, 200)

Concess.VehiclesMenu = RageUI.CreateSubMenu(Concess.ConcessMenu, Config['concess'].MenuTitle.MainMenu, Config['concess'].MenuSubTitle.VehiclesMenu, 8, 200)
Concess.OptionsVehicle = RageUI.CreateSubMenu(Concess.VehiclesMenu, Config['concess'].MenuTitle.MainMenu, Config['concess'].MenuSubTitle.OptionsVehicle, 8, 200)

local open = false
Concess.ColorIndex = 1

Concess.ConcessMenu.Closed = function()
    open = false

    for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['concess'].spawn[Concess.typeConcess].pos, 5.0)) do
        Framework.Game.DeleteVehicle(v)
    end

    Concess:DestroyCam()
end

Concess.VehiclesMenu.Closed = function(type)
    for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['concess'].spawn[Concess.typeConcess].pos, 5.0)) do
        Framework.Game.DeleteVehicle(v)
    end

    Concess:DestroyCam()
end

function Concess:OpenMenu(type)
    Concess.categorySelected = ''
    Concess.typeConcess = type

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Concess.ConcessMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Concess.ConcessMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Concess.ConcessMenu, true, true, true, function()

                    for k,v in pairs(Config['concess'].Vehicles.Categories[type]) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Concess.categorySelected = v.name
                            end
                        end, Concess.VehiclesMenu)
                    end
                end)

                RageUI.IsVisible(Concess.VehiclesMenu, true, true, true, function()
                    for k,v in pairs(Config['concess'].Vehicles.Vehicles[type]) do
                        if v.cat == Concess.categorySelected then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(v.price).."$"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    LastVehicle = nil
                                    Concess:ActiveCam(Config['concess'].spawn[type].camPos, Config['concess'].spawn[type].camROTX, Config['concess'].spawn[type].camFOV)
                                    
                                    if Framework.Game.IsSpawnPointClear(Config['concess'].spawn[type].pos, 5.0) then
                                        Framework.Game.SpawnLocalVehicle(v.model, Config['concess'].spawn[type].pos, Config['concess'].spawn[type].head, function(vehicle) 
                                            FreezeEntityPosition(vehicle, true)
                                            SetVehicleDoorsLocked(vehicle, 2)
                                            SetEntityInvincible(vehicle, true)
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDirtLevel(vehicle, 0.0)
                                            SetVehicleEngineOn(vehicle, true, true, true)
                                            SetVehicleLights(vehicle, 2)

                                            local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)

                                            Concess.LastVehicle = {
                                                model = v.model,
                                                label = v.label,
                                                price = v.price,
                                                vehicle = vehicle,
                                                props = vehicleProps
                                            }
                                        end)
                                    else
                                        for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['concess'].spawn[type].pos, 5.0)) do
                                            Framework.Game.DeleteVehicle(v)
                                        end

                                        Wait(500)

                                        Framework.Game.SpawnLocalVehicle(v.model, Config['concess'].spawn[type].pos, Config['concess'].spawn[type].head, function(vehicle) 
                                            FreezeEntityPosition(vehicle, true)
                                            SetVehicleDoorsLocked(vehicle, 2)
                                            SetEntityInvincible(vehicle, true)
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDirtLevel(vehicle, 0.0)
                                            SetVehicleEngineOn(vehicle, true, true, true)
                                            SetVehicleLights(vehicle, 2)
                                            
                                            local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)

                                            Concess.LastVehicle = {
                                                model = v.model,
                                                label = v.label,
                                                price = v.price,
                                                vehicle = vehicle,
                                                props = vehicleProps
                                            }
                                        end)
                                    end
                                end
                            end, Concess.OptionsVehicle)
                        end
                    end

                end)

                RageUI.IsVisible(Concess.OptionsVehicle, true, true, true, function()

                    if Concess.LastVehicle ~= nil then
                        RageUI.Separator("↓   Informations   ↓")

                        RageUI.ButtonWithStyle("Model : ~b~"..Concess.LastVehicle.label, nil, {}, true, function(Hovered, Active, Selected)
                        end)

                        RageUI.ButtonWithStyle("Prix : ~g~"..Framework.Math.GroupDigits(Concess.LastVehicle.price).."$", nil, {}, true, function(Hovered, Active, Selected)
                        end)

                        if DoesVehicleHaveDoor(Concess.LastVehicle.vehicle, 5) then
                            RageUI.ButtonWithStyle("Capacité du Coffre : ~b~"..(Config['vehicletrunk'].limits[GetVehicleClass(Concess.LastVehicle.vehicle)] or 5).." Kg", nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        else
                            RageUI.ButtonWithStyle("~r~Ce véhicule ne possède pas de coffre.~s~", nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        end

                        RageUI.Separator("↓   Actions   ↓")

                        RageUI.List("Couleur du Véhicule", {"Noir", "Bleu", "Blanc", "Rouge", "Vert", "Jaune"}, Concess.ColorIndex, "~b~Couleur du Véhicule", {}, true, function(Hovered, Active, Selected, Index)
                            Concess.ColorIndex = Index
                        end, function(Index)
                            if Index == 1 then
                                rgb = {0, 0, 0}
                            elseif Index == 2 then
                                rgb = {0, 160, 255}
                            elseif Index == 3 then
                                rgb = {255, 255, 255}
                            elseif Index == 4 then
                                rgb = {255, 0, 0}
                            elseif Index == 5 then
                                rgb = {0, 255, 0}
                            elseif Index == 6 then
                                rgb = {255, 255, 0}
                            end

                            SetVehicleCustomPrimaryColour(Concess.LastVehicle.vehicle, rgb[1], rgb[2], rgb[3])
                            SetVehicleCustomSecondaryColour(Concess.LastVehicle.vehicle, rgb[1], rgb[2], rgb[3])
                            Concess.LastVehicle.props = Framework.Game.GetVehicleProperties(Concess.LastVehicle.vehicle)
                        end)

                        RageUI.ButtonWithStyle("Acheter ~b~"..Concess.LastVehicle.label.." ~s~pour ~g~"..Framework.Math.GroupDigits(Concess.LastVehicle.price).."$", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                Framework.PaymentMethod(tonumber(Concess.LastVehicle.price), function(price, method)
                                    if price and method ~= nil then
                                        Framework.TriggerServerCallback("Concess:haveMoney", function(hasMoney)
                                            if hasMoney then
                                                for k,v in pairs(Framework.Game.GetVehiclesInArea(Config['concess'].spawn[type].pos, 5.0)) do
                                                    Framework.Game.DeleteVehicle(v)
                                                end
                                                Wait(500)
                                                Framework.Game.SpawnVehicle(Concess.LastVehicle.model, Config['concess'].spawn[type].pos, Config['concess'].spawn[type].head, function(vehicle)
                                                    Framework.Game.SetVehicleProperties(vehicle, Concess.LastVehicle.props)
    
                                                    local newPlate = Concess:GeneratePlate()
    
                                                    SetVehicleNumberPlateText(vehicle, newPlate)
    
                                                    vehicleProps = Framework.Game.GetVehicleProperties(vehicle)
                                                    exports["ac"]:ExecuteServerEvent('concess:buyVehicle', type, vehicleProps)
                                                end)
            
                                                Framework.ShowNotification("Vous avez acheté un nouveau Véhicule ! Pensez à faire les clefs.")
                                                Concess:DestroyCam()
                                            else
                                                Concess:DestroyCam()
                                            end
                                        end, {price = tonumber(Concess.LastVehicle.price), method = method})
                                    end
                                end)
                            end
                        end)

                    end

                end)
            end
        end)
    end
end