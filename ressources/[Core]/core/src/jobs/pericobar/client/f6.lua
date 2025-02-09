
PericoBarJob.F6Menu = RageUI.CreateMenu("Perico Bar", "~p~Perico Bar~s~: Actions", 8, 200)

PericoBarJob.InteractionsCitoyens = RageUI.CreateSubMenu(PericoBarJob.F6Menu, "Perico Bar", "~p~Perico Bar~s~: Interactions Citoyens", 8, 200)

PericoBarJob.AutresMenu = RageUI.CreateSubMenu(PericoBarJob.F6Menu, "Perico Bar", "~p~Perico Bar~s~: Autres", 8, 200)

local open = false

PericoBarJob.F6Menu.Closed = function()
    open = false
end

PericoBarJob.ServiceCheck = false

PericoBarJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PericoBarJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PericoBarJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PericoBarJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, PericoBarJob.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, PericoBarJob.AutresMenu)


                end)

                RageUI.IsVisible(PericoBarJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'pericobar', raison, amount)
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