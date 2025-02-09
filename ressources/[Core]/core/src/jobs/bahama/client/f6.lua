
BahamaJob.F6Menu = RageUI.CreateMenu("Bahama", "~p~Bahama~s~: Actions", 8, 200)

BahamaJob.InteractionsCitoyens = RageUI.CreateSubMenu(BahamaJob.F6Menu, "Bahama", "~p~Bahama~s~: Interactions Citoyens", 8, 200)

BahamaJob.AutresMenu = RageUI.CreateSubMenu(BahamaJob.F6Menu, "Bahama", "~p~Bahama~s~: Autres", 8, 200)

local open = false

BahamaJob.F6Menu.Closed = function()
    open = false
end

BahamaJob.ServiceCheck = false

BahamaJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BahamaJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BahamaJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(BahamaJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, BahamaJob.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, BahamaJob.AutresMenu)


                end)

                RageUI.IsVisible(BahamaJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'bahama', raison, amount)
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