
MecanoJob.F6Menu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Actions", 8, 200)

MecanoJob.InteractionsCitoyens = RageUI.CreateSubMenu(MecanoJob.F6Menu, "Mécano", "~p~Mécano~s~: Interactions Citoyens", 8, 200)

MecanoJob.InteractionsVehicules = RageUI.CreateSubMenu(MecanoJob.F6Menu, "Mécano", "~p~Mécano~s~: Interactions Vehicules", 8, 200)

MecanoJob.GestionsObjets = RageUI.CreateSubMenu(MecanoJob.F6Menu, "Mécano", "~p~Mécano~s~: Gestion Objets", 8, 200)

local open = false

MecanoJob.F6Menu.Closed = function()
    open = false
end

MecanoJob.ServiceCheck = false

MecanoJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(MecanoJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(MecanoJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(MecanoJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, MecanoJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            MecanoJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end

                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "Mécano",
                                            subject = "~o~Prise de Service",
                                            msg = "Le mécano ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_LSCUSTOM',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'mecano')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de mécanos en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'mecano')
                            else
                                local notification = {
                                    title = "Mécano",
                                    subject = "~r~Fin de Service",
                                    msg = "Le mécano ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_LSCUSTOM',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'mecano')
    
                                TriggerServerEvent("service:disableService", 'mecano')
                            end
                        end
                    end)

                    if MecanoJob.ServiceCheck then
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, MecanoJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Interactions Vehicules", nil, { RightLabel = "→→→" }, closestVeh ~= -1 and closestVehDistance < 5, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, MecanoJob.InteractionsVehicules)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, MecanoJob.GestionsObjets)
                    end

                end)

                RageUI.IsVisible(MecanoJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'mecano', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(MecanoJob.InteractionsVehicules, true, true, true, function()
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

                RageUI.IsVisible(MecanoJob.GestionsObjets, true, true, true, function()

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