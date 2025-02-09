
CayoAutoJob.F6Menu = RageUI.CreateMenu("Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Actions", 8, 200)

CayoAutoJob.InteractionsCitoyens = RageUI.CreateSubMenu(CayoAutoJob.F6Menu, "Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Interactions Citoyens", 8, 200)

CayoAutoJob.InteractionsVehicules = RageUI.CreateSubMenu(CayoAutoJob.F6Menu, "Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Interactions Vehicules", 8, 200)

CayoAutoJob.GestionsObjets = RageUI.CreateSubMenu(CayoAutoJob.F6Menu, "Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Gestion Objets", 8, 200)

CayoAutoJob.AutresMenu = RageUI.CreateSubMenu(CayoAutoJob.F6Menu, "Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Autres", 8, 200)

local open = false

CayoAutoJob.F6Menu.Closed = function()
    open = false
end

CayoAutoJob.ServiceCheck = false

CayoAutoJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CayoAutoJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, CayoAutoJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            CayoAutoJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end

                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "Cayo Perico Automobile",
                                            subject = "~o~Prise de Service",
                                            msg = "Le mécano ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_LSCUSTOM',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'cayoauto')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de mécanos en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'cayoauto')
                            else
                                local notification = {
                                    title = "Cayo Perico Automobile",
                                    subject = "~r~Fin de Service",
                                    msg = "Le mécano ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_LSCUSTOM',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'cayoauto')
    
                                TriggerServerEvent("service:disableService", 'cayoauto')
                            end
                        end
                    end)

                    if CayoAutoJob.ServiceCheck then
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CayoAutoJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Interactions Vehicules", nil, { RightLabel = "→→→" }, closestVeh ~= -1 and closestVehDistance < 5, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CayoAutoJob.InteractionsVehicules)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CayoAutoJob.GestionsObjets)
    
                        RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CayoAutoJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(CayoAutoJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'cayoauto', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(CayoAutoJob.InteractionsVehicules, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Réparer le Véhicule", nil, { RightLabel = "→"  }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            
                            if IsPedSittingInAnyVehicle(plyPed) then
                                Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cette action depuis un véhicule !")
                                return
                            end

                            if closestVeh == -1 or closestVehDistance > 3.0 then
                                Framework.ShowNotification("~r~Aucun Véhicules à Proximité !")
                            else
                                TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                                ProgressBars:startUI(15000, "Réparation...")
                                Wait(15000)
                                SetVehicleFixed(closestVeh)
                                SetVehicleDeformationFixed(closestVeh)
                                SetVehicleUndriveable(closestVeh, false)
                                SetVehicleEngineOn(closestVeh, true, true)
                                ClearPedTasksImmediately(plyPed)

                                Framework.ShowNotification("~g~Véhicule Réparer !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Nettoyer le Véhicule", nil, { RightLabel = "→"  }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()

                            if IsPedSittingInAnyVehicle(plyPed) then
                                Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cette action depuis un véhicule !")
                                return
                            end

                            if closestVeh == -1 or closestVehDistance > 3.0 then
                                Framework.ShowNotification("~r~Aucun Véhicules à Proximité !")
                            else
                                TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                                ProgressBars:startUI(10000, "Nettoyage...")
                                Wait(10000)
                                SetVehicleDirtLevel(closestVeh, 0)
                                ClearPedTasksImmediately(plyPed)

                                Framework.ShowNotification("~g~Véhicule Nettoyé !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre en fourrière", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()

                            TaskStartScenarioInPlace(plyPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				
                            ClearPedTasks(plyPed)
                            Wait(4000)
                            Framework.Game.DeleteVehicle(closestVeh)
                            ClearPedTasks(plyPed) 
                            Framework.ShowNotification("Véhicule mis en fourrière !")
                        end
                    end)

                    RageUI.ButtonWithStyle("Crocheter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if DoesEntityExist(closestVeh) then
                                local plyPed = PlayerPedId()
    
                                TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true)
                                Wait(20000)
                                ClearPedTasksImmediately(plyPed)
            
                                SetVehicleDoorsLocked(closestVeh, 1)
                                SetVehicleDoorsLockedForAllPlayers(closestVeh, false)
                                Framework.ShowNotification("Véhicule ~g~dévérouillé")
                            else
                                Framework.ShowNotification("~r~Aucun véhicule~s~ à proximité")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(CayoAutoJob.GestionsObjets, true, true, true, function()

                    RageUI.ButtonWithStyle("Plot", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local coords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                            local objCoords = (coords + forward * 1.0)
            
                            Framework.Game.SpawnObject('prop_roadcone02a', objCoords, function(obj)
                                SetEntityHeading(obj, GetEntityHeading(plyPed))
                                PlaceObjectOnGroundProperly(obj)
                            end)
                        end
                    end)

                end)
            end
        end)
    end
end