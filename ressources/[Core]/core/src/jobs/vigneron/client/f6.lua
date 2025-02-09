
VigneronJob.F6Menu = RageUI.CreateMenu("Vigneron", "~p~Vigneron~s~: Actions", 8, 200)

VigneronJob.Points = RageUI.CreateSubMenu(VigneronJob.F6Menu, "Vigneron", "~p~Vigneron~s~: Points", 8, 200)
VigneronJob.InteractionsCitoyens = RageUI.CreateSubMenu(VigneronJob.F6Menu, "Vigneron", "~p~Vigneron~s~: Interactions Citoyens", 8, 200)
VigneronJob.AutresMenu = RageUI.CreateSubMenu(VigneronJob.F6Menu, "Vigneron", "~p~Vigneron~s~: Autres", 8, 200)

local open = false

VigneronJob.F6Menu.Closed = function()
    open = false
end

VigneronJob.ServiceCheck = false

VigneronJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(VigneronJob.F6Menu, true, true, true, function()

                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, VigneronJob.InteractionsCitoyens)
    
                    RageUI.ButtonWithStyle("Points", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, VigneronJob.Points)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, VigneronJob.AutresMenu)
    
                end)

                RageUI.IsVisible(VigneronJob.Points, true, true, true, function()

                    RageUI.ButtonWithStyle("Récolte", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetNewWaypoint(Config['job_vigneron'].Points.harvest.pos.x, Config['job_vigneron'].Points.harvest.pos.y)
                        end
                    end)

                    RageUI.ButtonWithStyle("Traitement", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetNewWaypoint(Config['job_vigneron'].Points.craft.pos.x, Config['job_vigneron'].Points.craft.pos.y)
                        end
                    end)

                    RageUI.ButtonWithStyle("Vente", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetNewWaypoint(Config['job_vigneron'].Points.sell.pos.x, Config['job_vigneron'].Points.sell.pos.y)
                        end
                    end)

                end)

                RageUI.IsVisible(VigneronJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'vigneron', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)
            end
        end)
    end
end
