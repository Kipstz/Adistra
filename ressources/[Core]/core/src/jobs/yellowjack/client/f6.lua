
YellowJackJob.F6Menu = RageUI.CreateMenu("Yellow Jack", "~p~Yellow Jack~s~: Actions", 8, 200)

YellowJackJob.InteractionsCitoyens = RageUI.CreateSubMenu(YellowJackJob.F6Menu, "Yellow Jack", "~p~Yellow Jack~s~: Interactions Citoyens", 8, 200)

YellowJackJob.AutresMenu = RageUI.CreateSubMenu(YellowJackJob.F6Menu, "Yellow Jack", "~p~Yellow Jack~s~: Autres", 8, 200)

local open = false

YellowJackJob.F6Menu.Closed = function()
    open = false
end

YellowJackJob.ServiceCheck = false

YellowJackJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(YellowJackJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(YellowJackJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(YellowJackJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, YellowJackJob.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, YellowJackJob.AutresMenu)


                end)

                RageUI.IsVisible(YellowJackJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'yellowjack', raison, amount)
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