
HookahJob.F6Menu = RageUI.CreateMenu("Hookah", "~p~Hookah~s~: Actions", 8, 200)

HookahJob.InteractionsCitoyens = RageUI.CreateSubMenu(HookahJob.F6Menu, "Hookah", "~p~Hookah~s~: Interactions Citoyens", 8, 200)

HookahJob.AutresMenu = RageUI.CreateSubMenu(HookahJob.F6Menu, "Hookah", "~p~Hookah~s~: Autres", 8, 200)

local open = false

HookahJob.F6Menu.Closed = function()
    open = false
end

HookahJob.ServiceCheck = false

HookahJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(HookahJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(HookahJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(HookahJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, HookahJob.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, HookahJob.AutresMenu)


                end)

                RageUI.IsVisible(HookahJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'hookah', raison, amount)
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