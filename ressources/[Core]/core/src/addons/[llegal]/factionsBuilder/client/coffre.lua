
Factions.GestionMenu = RageUI.CreateMenu("Faction Management", "~p~Gestion Faction~s~: Actions", 8, 200)

Factions.BossMenu = RageUI.CreateSubMenu(Factions.GestionMenu, "Faction Management", "~p~Faction~s~: Actions Boss", 8, 200)
Factions.BossMenu = RageUI.CreateSubMenu(Factions.GestionMenu, "Faction Management", "~p~Faction~s~: Ba", 8, 200)
Factions.membresMenu = RageUI.CreateSubMenu(Factions.BossMenu, "Faction Management", "~p~Faction~s~: Gestion des Membres", 8, 200)
Factions.PromoteMenu = RageUI.CreateSubMenu(Factions.membresMenu, "Faction Management", "~p~Faction~s~: Promouvoir", 8, 200)

Factions.CoffreMenu = RageUI.CreateSubMenu(Factions.GestionMenu, "Faction Management", "~p~Coffre~s~: Actions", 8, 200)
Factions.DepositMenu = RageUI.CreateSubMenu(Factions.CoffreMenu, "Faction Management", "~p~Coffre~s~: Déposer un objet/une arme", 8, 200)
Factions.RemoveMenu = RageUI.CreateSubMenu(Factions.CoffreMenu, "Faction Management", "~p~Coffre~s~: Retirer un objet/une arme", 8, 200)

local open = false

Factions.GestionMenu.Closed = function()
    open = false
end

Factions.Indexs = {
    membGestion = 1
}

Factions.OpenGestionMenu = function(faction)
    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job2'].name == faction then else return end

    if Framework.PlayerData.jobs['job2'].grade == 0 and Framework.PlayerData.jobs['job2'].grade_name ~= 'boss' then
        Framework.ShowNotification("~r~Vous n'avez pas un grade asser élever !")
    end

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Factions.GestionMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Factions.GestionMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Factions.GestionMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Acceder au Coffre", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end, Factions.CoffreMenu)

                    if Framework.PlayerData.jobs['job2'].grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Acceder aux Actions Boss", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, Factions.BossMenu)
                    end

                end)
                
                RageUI.IsVisible(Factions.BossMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Gestion des Membres", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Factions.membres = {}

                            Framework.TriggerServerCallback("factions:getMembres", function(membres)
                                Factions.membres = membres
                            end, faction)
                        end
                    end, Factions.membresMenu)

                    
                    for k,v in pairs(Config['factions'].factionsCanWash) do
                        if faction == v then
                            RageUI.ButtonWithStyle("Blanchir de l'argent", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local amount = VisualManager:KeyboardOutput("Montant", "", 10)
        
                                    if tonumber(amount) then
                                        exports["ac"]:ExecuteServerEvent('factions:washMoney', faction, tonumber(amount))
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end

                end)
                
                RageUI.IsVisible(Factions.membresMenu, true, true, true, function()

                    for k,v in pairs(Factions.membres) do
                        local gradeLabel = (v.job2.grade_label == '' and v.job2.label or v.job2.grade_label)

                        RageUI.List(v.name, { "Promouvoir", "Virer" }, Factions.Indexs.membGestion, gradeLabel, {}, true, function(Hovered, Active, Selected, Index)
                            Factions.Indexs.membGestion = Index

                            if Selected then
                                if Index == 1 then
                                    Factions.promoteJobs2 = {}

                                    Framework.TriggerServerCallback("factions:getJob2", function(jobs2)
                                        Factions.promoteJobs2 = jobs2
                                    end, faction)

                                    RageUI.CloseAll()

                                    RageUI.Visible(Factions.PromoteMenu, true)

                                    Factions.promotePlayerIdentifier = v.identifier
                                    Factions.promotePlayerCharacterID = v.characterId
                                elseif Index == 2 then
                                    exports["ac"]:ExecuteServerEvent("factions:virer2", v.characterId, v.identifier)

                                    RageUI.GoBack()
                                end
                            end
                        end)
                    end

                    -- RageUI.Line()

                    -- RageUI.ButtonWithStyle("Recruter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    -- end)

                end)

                RageUI.IsVisible(Factions.PromoteMenu, true, true, true, function()
                    if next(Factions.promoteJobs2) then
                        for k,v in pairs(Factions.promoteJobs2.grades) do
                            local gradeLabel = (v.label == '' and Factions.promoteJobs2.label or v.label)
    
                            RageUI.ButtonWithStyle(gradeLabel, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    exports["ac"]:ExecuteServerEvent("factions:promote2", Factions.promotePlayerCharacterID, Factions.promotePlayerIdentifier, faction, v.grade)
                                
                                    RageUI.GoBack()
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(Factions.CoffreMenu, true, true, true, function()

                    RageUI.Separator("Argent Sale : ~p~"..SharedFactions[faction].data["accounts"]['black_money'].."$~s~")

                    RageUI.ButtonWithStyle("Déposer de l'argent Sale", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = VisualManager:KeyboardOutput("Montant", "", 5)

                            if tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('factions:depositMoney', faction, tonumber(amount))
                            else
                                Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                            end
                        end
                    end)

                    if Framework.PlayerData.jobs['job2'].grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Retirer de l'argent Sale", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local amount = VisualManager:KeyboardOutput("Montant", "", 5)
    
                                if tonumber(amount) then
                                    exports["ac"]:ExecuteServerEvent('factions:removeMoney', faction, tonumber(amount))
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                end
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle("Actualiser l'argent", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('factions:getFactionMoney', function(money) 
                                SharedFactions[faction].data["accounts"]['black_money'] = money
                            end, faction)
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Déposer un objet/une arme", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end, Factions.DepositMenu)

                    if Framework.PlayerData.jobs['job2'].grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Retirer un objet/une arme", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Framework.TriggerServerCallback('factions:getCoffre', function(coffre) 
                                    SharedFactions[faction].data = coffre
                                end, faction)
                            end
                        end, Factions.RemoveMenu)
                    end
                end)

                RageUI.IsVisible(Factions.DepositMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Mon Inventaire~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.inventory) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                    if tonumber(qte) then
                                        RageUI.GoBack()

                                        exports["ac"]:ExecuteServerEvent('factions:deposit', faction, 'item_standard', v, tonumber(qte))
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Mes armes~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.loadout) do
                        RageUI.ButtonWithStyle("[~o~"..v.ammo.."Muns~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if not Framework.WeaponisBoutique(v.name) then
                                    RageUI.GoBack()

                                    exports["ac"]:ExecuteServerEvent('factions:deposit', faction, 'item_weapon', v)
                                else
                                    Framework.ShowNotification("~r~Vous ne pouvez pas déposer une arme boutique !")
                                end
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(Factions.RemoveMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Objets~s~   ↓")

                    for k,v in pairs(SharedFactions[faction].data["items"]) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                    if tonumber(qte) then
                                        RageUI.GoBack()

                                        exports["ac"]:ExecuteServerEvent('factions:remove', faction, 'item_standard', v, tonumber(qte))
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Armes~s~   ↓")

                    for k,v in pairs(SharedFactions[faction].data["weapons"]) do
                        RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "[~o~"..v.ammo.."Muns~s~]" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.GoBack()

                                exports["ac"]:ExecuteServerEvent('factions:remove', faction, 'item_weapon', v)
                            end
                        end)
                    end
                end)

            end
        end)
    end
end
