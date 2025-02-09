Banques.Main = RageUI.CreateMenu(Config["banques"].MenuTitle.MainMenu, Config["banques"].MenuSubTitle.MainMenu, 8, 200)

Banques.EpargneMenu = RageUI.CreateSubMenu(Banques.Main, Config["banques"].MenuTitle.MainMenu, Config["banques"].MenuSubTitle.EpargneMenu, 8, 200)

local open = false

Banques.Main.Closed = function()
    open = false
end

function Banques:OpenMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Banques.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Banques.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Banques.Main, true, true, true, function()

                    RageUI.ButtonWithStyle("Solde", nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(Framework.PlayerData.accounts['bank'].money).."$"}, true, function(Hovered, Active, Selected)
                    end)

                    RageUI.ButtonWithStyle("Déposer de l'argent", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local qte = VisualManager:KeyboardOutput("Montant", "", 15)

                            if VisualManager:keyboardIsValid(qte, true) then
                                exports["ac"]:ExecuteServerEvent('banques:deposit', tonumber(qte))
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Retirer de l'argent", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local qte = VisualManager:KeyboardOutput("Montant", "", 15)

                            if VisualManager:keyboardIsValid(qte, true) then
                                exports["ac"]:ExecuteServerEvent('banques:remove', tonumber(qte))
                            end
                        end
                    end)

                    -- RageUI.Line()

                    -- RageUI.ButtonWithStyle("Ouvrir un Compte Épargne", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    --     if Selected then
                    --     end
                    -- end)

                    -- RageUI.ButtonWithStyle("Acceder au Compte Épargne", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    -- end, Banques.EpargneMenu)

                end)

                RageUI.IsVisible(Banques.EpargneMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Solde", nil, { RightLabel = "~g~"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer de l'argent", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)

                    RageUI.ButtonWithStyle("Retirer de l'argent", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Retour", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.GoBack()
                        end
                    end)

                end)
            end
        end)
    end
end