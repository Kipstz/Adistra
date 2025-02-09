
TequilalaJob.F6Menu = RageUI.CreateMenu("Tequi-la-la", "~p~Tequi-la-la~s~: Actions", 8, 200)

TequilalaJob.InteractionsCitoyens = RageUI.CreateSubMenu(TequilalaJob.F6Menu, "Tequi-la-la", "~p~Tequi-la-la~s~: Interactions Citoyens", 8, 200)

TequilalaJob.AutresMenu = RageUI.CreateSubMenu(TequilalaJob.F6Menu, "Tequi-la-la", "~p~Tequi-la-la~s~: Autres", 8, 200)

local open = false

TequilalaJob.F6Menu.Closed = function()
    open = false
end

TequilalaJob.ServiceCheck = false

TequilalaJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(TequilalaJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(TequilalaJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(TequilalaJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, TequilalaJob.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, TequilalaJob.AutresMenu)


                end)

                RageUI.IsVisible(TequilalaJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'tequilala', raison, amount)
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