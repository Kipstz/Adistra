
Coffres.MainMenu = RageUI.CreateMenu("Coffres", "Coffre:", 8, 200)

Coffres.DepositMenu = RageUI.CreateSubMenu(Coffres.MainMenu, "Coffres", "Coffre: Déposer", 8, 200)
Coffres.RemoveMenu = RageUI.CreateSubMenu(Coffres.MainMenu, "Coffres", "Coffre: Retirer", 8, 200)

local open = false

Coffres.MainMenu.Closed = function()
    open = false
end

function Coffres:OpenCoffreMenu(coffreId, data)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Coffres.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Coffres.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Coffres.MainMenu, true, true, true, function()

                    RageUI.Separator("Id du Coffre: ~b~"..coffreId.."~s~")

                    RageUI.ButtonWithStyle("Déposer un objet", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Coffres.DepositMenu)

                    RageUI.ButtonWithStyle("Retirer un objet", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Coffres.RemoveMenu)

                end)

                RageUI.IsVisible(Coffres.DepositMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Mon Inventaire~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.inventory) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle("[~b~"..v.count.."~s~] - ~p~"..v.label, nil, { RightLabel = "~o~Déposer~s~" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                    if tonumber(qte) and tonumber(qte) > 0 and tonumber(v.count) >= tonumber(qte) then
                                        exports["ac"]:ExecuteServerEvent("coffres:deposit", 'item_standard', v, tonumber(qte), coffreId)

                                        open = false
                                        RageUI.CloseAll()
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end

                    -- RageUI.Separator("↓   ~r~Mes armes~s~   ↓")

                    -- for k,v in pairs(ESX.PlayerData.loadout) do
                    --     RageUI.ButtonWithStyle("[~o~"..v.ammo.."Muns~s~] - ~r~"..v.label, nil, { RightLabel = "~b~Déposer~s~" }, true, function(Hovered, Active, Selected)
                    --         if Selected then
                    --             exports["ac"]:ExecuteServerEvent("coffre:deposit", 'item_weapon', v, qte, coffreId)
                    --         end
                    --     end)
                    -- end

                end)

                RageUI.IsVisible(Coffres.RemoveMenu, true, true, true, function()

                    RageUI.Separator("↓   ~r~Objets~s~   ↓")

                    if not next(data.inventory) then
                        RageUI.ButtonWithStyle("~r~Aucun objet !~s~", nil, {}, false, function(Hovered, Active, Selected)
                        end)
                    else
                        for k,v in pairs(data.inventory) do
                            if v.count > 0 then
                                RageUI.ButtonWithStyle("[~b~"..v.count.."~s~] - ~p~"..v.label, nil, { RightLabel = "~o~Retirer~s~" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        local qte = VisualManager:KeyboardOutput("Quantité", "", 5)
    
                                        if tonumber(qte) and tonumber(qte) > 0 and tonumber(v.count) >= tonumber(qte) then
                                            exports["ac"]:ExecuteServerEvent("coffres:remove", 'item_standard', v, tonumber(qte), coffreId)

                                            open = false
                                            RageUI.CloseAll()
                                        else
                                            Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                        end
                                    end
                                end)
                            end
                        end
                    end

                    -- RageUI.Separator("↓   ~r~Armes~s~   ↓")

                    -- if #data3 == 0 then
                    --     RageUI.ButtonWithStyle("Aucune arme !", nil, {}, false, function(Hovered, Active, Selected)
                    --     end)
                    -- else

                    -- end

                end)
            end
        end)
    end
end