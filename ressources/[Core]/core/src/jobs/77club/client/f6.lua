
NightClub.F6Menu = RageUI.CreateMenu("77-Club", "~p~77-Club~s~: Actions", 8, 200)

NightClub.InteractionsCitoyens = RageUI.CreateSubMenu(NightClub.F6Menu, "77-Club", "~p~77-Club~s~: Interactions Citoyens", 8, 200)

NightClub.AutresMenu = RageUI.CreateSubMenu(NightClub.F6Menu, "77-Club", "~p~77-Club~s~: Autres", 8, 200)

local open = false

NightClub.F6Menu.Closed = function()
    open = false
end

NightClub.ServiceCheck = false

NightClub.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(NightClub.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(NightClub.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(NightClub.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, NightClub.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, NightClub.AutresMenu)


                end)

                RageUI.IsVisible(NightClub.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), '77club', raison, amount)
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