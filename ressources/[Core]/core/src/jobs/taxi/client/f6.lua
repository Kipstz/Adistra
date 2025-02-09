
TaxiJob.F6Menu = RageUI.CreateMenu("Taxi", "~p~Taxi~s~: Actions", 8, 200)

TaxiJob.InteractionsCitoyens = RageUI.CreateSubMenu(TaxiJob.F6Menu, "Taxi", "~p~Taxi~s~: Interactions Citoyens", 8, 200)

TaxiJob.AutresMenu = RageUI.CreateSubMenu(TaxiJob.F6Menu, "Taxi", "~p~Taxi~s~: Autres", 8, 200)

local open = false

TaxiJob.F6Menu.Closed = function()
    open = false
end

TaxiJob.ServiceCheck = false

TaxiJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(TaxiJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(TaxiJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(TaxiJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, TaxiJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            TaxiJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end
                            
                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "Taxi",
                                            subject = "~o~Prise de Service",
                                            msg = "Le chauffeur ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_TAXI',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'taxi')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de chauffeurs en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'taxi')
                            else
                                local notification = {
                                    title = "Taxi",
                                    subject = "~r~Fin de Service",
                                    msg = "Le chauffeur ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_TAXI',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'taxi')
    
                                TriggerServerEvent("service:disableService", 'taxi')
                            end
                        end
                    end)

                    if TaxiJob.ServiceCheck then
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                        
                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, TaxiJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, TaxiJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(TaxiJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'taxi', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(TaxiJob.AutresMenu, true, true, true, function()
                    RageUI.Separator("↓ ~p~Missions~s~ ↓")

                    RageUI.ButtonWithStyle("Lancer une mission", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if not TaxiJob.isInMission then
                                TaxiJob:startMission()
                            else
                                Framework.ShowNotification("~r~Vous êtes déjà en mission !~s~")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Arrêter la mission en cours", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if TaxiJob.isInMission then
                                TaxiJob:stopMission()
                            else
                                Framework.ShowNotification("~r~Vous n'êtes pas en mission !~s~")
                            end
                        end
                    end)

                end)

            end
        end)
    end
end