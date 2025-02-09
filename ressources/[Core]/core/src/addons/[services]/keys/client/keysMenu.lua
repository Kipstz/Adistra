Keys.KeysMenu = RageUI.CreateMenu("Mes Clés", "Clés:", 8, 200)
Keys.SelectedMenu = RageUI.CreateSubMenu(Keys.KeysMenu, "Clé", "Clé:", 8, 200)

local open = false

Keys.KeysMenu.Closed = function()
    open = false
end

function Keys:OpenKeysMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Keys.KeysMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Keys.KeysMenu, true)
        open = true

        Keys.myKeys = {}

        Framework.TriggerServerCallback('keys:getMyKeys', function(myKeys)
            Keys.myKeys = myKeys;
        end)

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Keys.KeysMenu, true, true, true, function()

                    if Keys.myKeys ~= nil then
                        for k,v in pairs(Keys.myKeys) do
                            RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..v.vehicleLabel, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    Keys.selectedVehicle = {
                                        characterId = v.characterId,
                                        vehicleLabel = v.vehicleLabel,
                                        plate = v.plate
                                    }
                                end
                            end, Keys.SelectedMenu)
                        end
                    end
                end)

                RageUI.IsVisible(Keys.SelectedMenu, true, true, true, function()

                    RageUI.Separator("↓ Informations ↓")

                    RageUI.ButtonWithStyle("Nom: ~g~"..Keys.selectedVehicle.vehicleLabel, nil, {}, true, function(Hovered, Active, Selected) end)

                    RageUI.ButtonWithStyle("Plaque: ~b~"..Keys.selectedVehicle.plate, nil, {}, true, function(Hovered, Active, Selected) end)

                    if Keys.selectedVehicle.temporary ~= nil then
                        RageUI.ButtonWithStyle("Statut: ~b~"..Keys.selectedVehicle.temporary, nil, {}, true, function(Hovered, Active, Selected) end)
                    end

                    if Keys.selectedVehicle.temporary == nil then
                        RageUI.Separator("↓ Actions ↓")

                        RageUI.ButtonWithStyle("Donner", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer()
                                if closestPlayer ~= -1 and closestPlayerDistance < 1.5 then
                                    local plyPed = PlayerPedId()
                                    local plyCoords = GetEntityCoords(plyPed)
    
                                    local vehicle = Framework.Game.GetClosestVehicle(plyCoords)
                                    local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)
    
                                    if vehicle ~= nil and vehicleProps.plate == Keys.selectedVehicle.plate then
                                        exports["ac"]:ExecuteServerEvent('keys:donner', GetPlayerServerId(closestPlayer), Keys.selectedVehicle.plate, vehicleProps)
                                        RageUI.CloseAll()
                                    else
                                        Framework.ShowAdvancedNotification("~r~Aucun véhicule étant attribué à ces clés à proximité. (Veuillez sortir le véhicule si ce n'est pas fait)~s~")
                                    end
                                else
                                    Framework.ShowNotification("~r~Personne a proximité !~s~")
                                end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Prêter", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer()
    
                                if closestPlayer ~= -1 and closestPlayerDistance < 1.5 then
                                    exports["ac"]:ExecuteServerEvent('keys:preter', GetPlayerServerId(closestPlayer), Keys.selectedVehicle)
                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Personne a proximité !~s~")
                                end
                            end
                        end)
                    end
                end)

            end
        end)
    end
end

RegisterNetEvent('keys:open')
AddEventHandler('keys:open', function()
    Keys:OpenKeysMenu()
end)