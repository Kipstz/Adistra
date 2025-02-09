
VehicleTrunk.MainMenu = RageUI.CreateMenu("Coffre", "Accéder a votre Coffre", 8, 200)

VehicleTrunk.DeposerMenu = RageUI.CreateSubMenu(VehicleTrunk.MainMenu, "Coffre", "Déposer un objet", 8, 200)
VehicleTrunk.RetireMenu = RageUI.CreateSubMenu(VehicleTrunk.MainMenu, "Coffre", "Retirer un objet", 8, 200)

local open = false

VehicleTrunk.MainMenu.Closed = function()
    SetVehicleDoorShut(VehicleTrunk.selectedVeh, 5, false)
    open = false
    VehicleTrunk.selectedVeh = nil
end

VehicleTrunk.OpenTrunkMenu = function(veh, class)
    MaxWeight = Config['vehicletrunk'].limits[class]
    VehicleTrunk.data = {
        weight = 0.0,
        accounts = {},
        items = {},
        weapons = {}
    }

    if open then
        RageUI.CloseAll()
        RageUI.Visible(VehicleTrunk.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(VehicleTrunk.MainMenu, true)
        open = true

        SetVehicleDoorOpen(VehicleTrunk.selectedVeh, 5, false, false)

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(VehicleTrunk.MainMenu, true, true, true, function()

                    RageUI.Separator("Plaque: ~b~"..GetVehicleNumberPlateText(veh).."~s~")

                    RageUI.ButtonWithStyle("Déposer un objet", nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
                    end, VehicleTrunk.DeposerMenu)

                    RageUI.ButtonWithStyle("Retirer un objet", nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
                        if Selected then
                            VehicleTrunk.data = {
                                weight = 0.0,
                                accounts = {},
                                items = {},
                                weapons = {}
                            }

                            VehicleTrunk.RetireMenu:SetSubtitle("Poids du Coffre: ~b~" .. VehicleTrunk.data.weight .. " ~s~/~r~ " .. MaxWeight .. " ~s~KG")
                            Framework.TriggerServerCallback('vehicletrunk:getTrunkInventory', function(data)
                                if data ~= nil then
                                    if data.plate == GetVehicleNumberPlateText(veh) then
                                        VehicleTrunk.data = data
    
                                        VehicleTrunk.RetireMenu:SetSubtitle("Poids du Coffre: ~b~" .. VehicleTrunk.data.weight .. " ~s~/~r~ " .. MaxWeight .. " ~s~KG")
                                    else
                                        Framework.ShowNotification("~r~Plaque du véhicule invalide !~s~")
                                    end
                                end
                            end, GetVehicleNumberPlateText(veh))
                        end
                    end, VehicleTrunk.RetireMenu)

                end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                RageUI.IsVisible(VehicleTrunk.DeposerMenu, true, true, true, function()

                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                        Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                        RageUI.CloseAll()
                    else
                        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)
                        if closestVeh == veh and closestVehDistance < 4.5 then
                            RageUI.Separator("↓   Argent   ↓")
                    
                            for k,v in pairs(Framework.PlayerData.accounts) do
                                if v.name == 'money' then
                                    RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(v.money).."$~s~" },true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
        
                                            if tonumber(qte) and tonumber(qte) > 0 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                    Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                                else
                                                    if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                        Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                    else
                                                        Wait(math.random(1, 1000))
                                                        exports["ac"]:ExecuteServerEvent('vehicletrunk:deposit', 'item_accounts', GetVehicleNumberPlateText(veh), v, tonumber(qte), MaxWeight)
                                                        RageUI.CloseAll()
                                                    end
                                                end
                                            else
                                                Framework.ShowNotification("~r~Quantité Invalide !")
                                            end
                                        end
                                    end)
                                elseif v.name == 'black_money' then
                                    RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~r~"..Framework.Math.GroupDigits(v.money).."$~s~" },true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10) 
        
                                            if tonumber(qte) and tonumber(qte) > 0 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                    Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                                else
                                                    if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                        Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                    else
                                                        Wait(math.random(1, 1000))
                                                        exports["ac"]:ExecuteServerEvent('vehicletrunk:deposit', 'item_accounts', GetVehicleNumberPlateText(veh), v, tonumber(qte), MaxWeight)
                                                        RageUI.CloseAll()
                                                    end
                                                end
                                            else
                                                Framework.ShowNotification("~r~Quantité Invalide !")
                                            end
                                        end
                                    end)
                                end
                            end
        
                            RageUI.Separator("↓   Objets   ↓")
        
                            for k,v in pairs(Framework.PlayerData.inventory) do
                                if v.count > 0 then
                                    RageUI.ButtonWithStyle("~b~"..v.count.."x ~s~- "..v.label, nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10) 
        
                                            if tonumber(qte) and tonumber(qte) > 0 then
                                                print(v.name)
                                                if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                    Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                                else
                                                    if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                        Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                    else
                                                        Wait(math.random(1, 1000))
                                                        exports["ac"]:ExecuteServerEvent('vehicletrunk:deposit', 'item_standard', GetVehicleNumberPlateText(veh), v, tonumber(qte), MaxWeight)
                                                        RageUI.CloseAll()
                                                    end
                                                end
                                            else
                                                Framework.ShowNotification("~r~Quantité Invalide !")
                                            end
                                        end
                                    end)
                                end
                            end
        
                            RageUI.Separator("↓   Armes   ↓")
                            
                            for k,v in pairs(Framework.PlayerData.loadout) do
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~o~"..v.ammo.."~s~ →" },true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if not Framework.WeaponisBoutique(v.name) then
                                            if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                            else
                                                if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                    Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                else
                                                    Wait(math.random(1, 1000))
                                                    exports["ac"]:ExecuteServerEvent('vehicletrunk:deposit', 'item_weapon', GetVehicleNumberPlateText(veh), v, 0, MaxWeight)
                                                    Wait(1000)
                                                    RageUI.CloseAll()
                                                end
                                            end
                                        else
                                            Framework.ShowNotification("~r~Vous ne pouvez pas retiré une arme boutique !")
                                        end
                                    end
                                end)
                            end
                        else
                            Framework.ShowNotification("~r~Action Impossible, aucun véhicule à proximité !")
                            RageUI.CloseAll()
                        end
                    end

                end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                RageUI.IsVisible(VehicleTrunk.RetireMenu, true, true, true, function()

                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                        Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                        RageUI.CloseAll()
                    else
                        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)
                        if closestVeh == veh and closestVehDistance < 4.5 then
                            RageUI.Separator("↓   Argent   ↓")
                    
                            for k,v in pairs(VehicleTrunk.data.accounts) do
                                if k == 'money' then
                                    RageUI.ButtonWithStyle("Argent", nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(v).."$~s~" },true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10) 
        
                                            if tonumber(qte) and tonumber(qte) > 0 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                    Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                                else
                                                    if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                        Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                    else
                                                        Wait(math.random(1, 1000))
                                                        exports["ac"]:ExecuteServerEvent('vehicletrunk:remove', 'item_accounts', GetVehicleNumberPlateText(veh), {name = 'money', count = v}, tonumber(qte))
                                                        RageUI.CloseAll()
                                                    end
                                                end
                                            else
                                                Framework.ShowNotification("~r~Quantité Invalide !")
                                            end
                                        end
                                    end)
                                elseif k == 'black_money' then
                                    RageUI.ButtonWithStyle("Argent Sale", nil, { RightLabel = "~r~"..Framework.Math.GroupDigits(v)
                                    .."$~s~" },true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10) 
        
                                            if tonumber(qte) and tonumber(qte) > 0 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                    Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                                else
                                                    if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                        Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                    else
                                                        Wait(math.random(1, 1000))
                                                        exports["ac"]:ExecuteServerEvent('vehicletrunk:remove', 'item_accounts', GetVehicleNumberPlateText(veh), {name = 'black_money', count = v}, tonumber(qte))
                                                        RageUI.CloseAll()
                                                    end
                                                end
                                            else
                                                Framework.ShowNotification("~r~Quantité Invalide !")
                                            end
                                        end
                                    end)
                                end
                            end
        
                            RageUI.Separator("↓   Objets   ↓")
        
                            for k,v in pairs(VehicleTrunk.data.items) do
                                if v.count > 0 then
                                    RageUI.ButtonWithStyle("~b~"..v.count.."x ~s~- "..v.label, nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10) 
        
                                            if tonumber(qte) and tonumber(qte) > 0 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                    Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                                else
                                                    if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                        Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                    else
                                                        Wait(math.random(1, 1000))
                                                        exports["ac"]:ExecuteServerEvent('vehicletrunk:remove', 'item_standard', GetVehicleNumberPlateText(veh), v, tonumber(qte))
                                                        RageUI.CloseAll()
                                                    end
                                                end
                                            else
                                                Framework.ShowNotification("~r~Quantité Invalide !")
                                            end
                                        end
                                    end)
                                end
                            end
        
                            RageUI.Separator("↓   Armes   ↓")
                            
                            for k,v in pairs(VehicleTrunk.data.weapons) do
                                RageUI.ButtonWithStyle("~b~"..v.count.."x ~s~- "..v.label, nil, { RightLabel = "~o~"..v.ammo.."~s~ →" },true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if not Framework.WeaponisBoutique(v.name) then
                                            if closestPlayer ~= -1 and closestPlayerDistance < 11.5 then
                                                Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                                            else
                                                if closestVeh ~= veh and closestVehDistance < 3.5 then
                                                    Framework.ShowNotification("~r~Action Impossible (le véhicule n'est plus à proximité) !")
                                                else
                                                    Wait(math.random(1, 1000))
                                                    exports["ac"]:ExecuteServerEvent('vehicletrunk:remove', 'item_weapon', GetVehicleNumberPlateText(veh), v)
                                                    Wait(1000)
                                                    RageUI.CloseAll()
                                                end
                                            end
                                        else
                                            Framework.ShowNotification("~r~Vous ne pouvez pas retiré une arme boutique !")
                                        end
                                    end
                                end)
                            end
                        else
                            Framework.ShowNotification("~r~Action Impossible, aucun véhicule à proximité !")
                            RageUI.CloseAll()
                        end
                    end

                end)
            end
        end)
    end
end