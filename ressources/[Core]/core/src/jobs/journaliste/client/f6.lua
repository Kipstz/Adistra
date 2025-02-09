
JournalisteJob.F6Menu = RageUI.CreateMenu("Weazel-News", "~p~Journaliste~s~: Actions", 8, 200)

JournalisteJob.InteractionsCitoyens = RageUI.CreateSubMenu(JournalisteJob.F6Menu, "Weazel-News", "~p~Journaliste~s~: Interactions Citoyens", 8, 200)
JournalisteJob.GestionsObjets = RageUI.CreateSubMenu(JournalisteJob.F6Menu, "Weazel-News", "~p~Journaliste~s~: Gestion des Objets", 8, 200)
JournalisteJob.AutresMenu = RageUI.CreateSubMenu(JournalisteJob.F6Menu, "Weazel-News", "~p~Journaliste~s~: Autres", 8, 200)

local open = false

JournalisteJob.F6Menu.Closed = function()
    open = false
end

JournalisteJob.ServiceCheck = false

JournalisteJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(JournalisteJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(JournalisteJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(JournalisteJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, JournalisteJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            JournalisteJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end

                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "Weazel-News",
                                            subject = "~o~Prise de Service",
                                            msg = "Le journaliste ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_WEAZEL',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'journalist')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de journalistes en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'journalist')
                            else
                                local notification = {
                                    title = "Weazel-News",
                                    subject = "~r~Fin de Service",
                                    msg = "Le journaliste ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_WEAZEL',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'journalist')
    
                                TriggerServerEvent("service:disableService", 'journalist')
                            end
                        end
                    end)

                    if JournalisteJob.ServiceCheck then
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, JournalisteJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, JournalisteJob.GestionsObjets)
    
                        RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, JournalisteJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(JournalisteJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'journalist', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(JournalisteJob.GestionsObjets, true, true, true, function()

                    RageUI.Separator("↓   ~b~Props   ~s~↓")

                    RageUI.ButtonWithStyle("Sortir la caméra", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("cam")
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Sortir le micro", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("mic") 
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Sortir le micro perche", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("bmic")
                        end
                    end)
                    
                end)
            end
        end)
    end
end