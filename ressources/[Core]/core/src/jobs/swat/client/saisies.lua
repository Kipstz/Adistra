SwatJob.SaisiesMenu = RageUI.CreateMenu("SWAT", "~p~SWAT~s~: Saisies", 8, 200)

SwatJob.AddSaisieMenu = RageUI.CreateSubMenu(SwatJob.SaisiesMenu, "SWAT", "~p~SWAT~s~: Ajouter une Saisie", 8, 200)
SwatJob.SaisieInventoryMenu = RageUI.CreateSubMenu(SwatJob.AddSaisieMenu, "SWAT", "~p~SWAT~s~: Objets de la Saisie", 8, 200)

SwatJob.GestionSaisiesMenu = RageUI.CreateSubMenu(SwatJob.SaisiesMenu, "SWAT", "~p~SWAT~s~: Saisies", 8, 200)
SwatJob.SelectedSaisieMenu = RageUI.CreateSubMenu(SwatJob.GestionSaisiesMenu, "SWAT", "~p~SWAT~s~: Saisies", 8, 200)
SwatJob.EditSaisieMenu = RageUI.CreateSubMenu(SwatJob.SelectedSaisieMenu, "SWAT", "~p~SWAT~s~: Saisies", 8, 200)
SwatJob.EditSaisieInventoryMenu = RageUI.CreateSubMenu(SwatJob.EditSaisieMenu, "SWAT", "~p~SWAT~s~: Saisies", 8, 200)

local open = false

SwatJob.SaisiesMenu.Closed = function()
    open = false
end

SwatJob.OpenSaisiesMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SwatJob.SaisiesMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SwatJob.SaisiesMenu, true)
        open = true

        SwatJob.saisies = {}
        SwatJob.selectedSaisie = {}

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(SwatJob.SaisiesMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter une Saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwatJob.buildSaisie = {
                                appartenance = '',
                                motif = '',
                                accounts = {},
                                items = {},
                                weapons = {},
                            }
                        end
                    end, SwatJob.AddSaisieMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Acceder aux Saisies", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('SwatJob:getAllSaisies', function(saisies)
                                SwatJob.saisies = saisies
                            end)
                        end
                    end, SwatJob.GestionSaisiesMenu)
                end)

                RageUI.IsVisible(SwatJob.AddSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance", "A qui appartient la saisie (ex: un gang, orga ...etc) \nAppartenance: ~b~"..SwatJob.buildSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                SwatJob.buildSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..SwatJob.buildSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                SwatJob.buildSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Déposer les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwatJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("SwatJob:getSaisiePlayerData", function(data) 
                                SwatJob.saisiePlayerData = data
                            end)
                        end
                    end, SwatJob.SaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider la saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if SwatJob.buildSaisie.appartenance ~= '' and SwatJob.buildSaisie.motif ~= '' then
                                if next(SwatJob.buildSaisie.accounts) or next(SwatJob.buildSaisie.items) or next(SwatJob.buildSaisie.weapons) then
                                    TriggerServerEvent('SwatJob:addSaisie', SwatJob.buildSaisie)
                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Invalide !~s~")
                                end
                            else
                                Framework.ShowNotification("~r~Invalide !~s~")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(SwatJob.SaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(SwatJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(SwatJob.buildSaisie.items) then
                                        table.insert(SwatJob.buildSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = v.itemCount - qte
                                    else
                                        for k2,v2 in pairs(SwatJob.buildSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(SwatJob.buildSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                        end

                                        v.itemCount = v.itemCount - qte
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~o~Vos Armes~s~ ↓")

                    for k,v in pairs(SwatJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not Framework.WeaponisBoutique(v.name) then
                                    if not next(SwatJob.buildSaisie.weapons) then
                                        table.insert(SwatJob.buildSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.remove(SwatJob.saisiePlayerData.loadout, k)
                                    else
                                        for k2,v2 in pairs(SwatJob.buildSaisie.weapons) do
                                            if v.weaponName == v2.weaponName then
                                                weaponFound = true;
                                                v2.count = tonumber(v2.count + 1)
                                            end
                                        end
    
                                        if not weaponFound then
                                            table.insert(SwatJob.buildSaisie.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
    
                                        table.remove(SwatJob.saisiePlayerData.loadout, k)
                                    end
                                else
                                    Framework.ShowNotification("~r~Vous ne pouvez pas déposer une arme boutique !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SwatJob.buildSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and tonumber(v.itemCount) >= tonumber(qte) then v.itemCount = tonumber(v.itemCount - qte) end
                                if v.itemCount == 0 then table.remove(SwatJob.buildSaisie.items, k) end

                                for k2,v2 in pairs(SwatJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end
                            end
                        end)
                    end

                    for k,v in pairs(SwatJob.buildSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = tonumber(v.count - 1)
                                if v.count == 0 then table.remove(SwatJob.buildSaisie.weapons, k) end
                                table.insert(SwatJob.saisiePlayerData.loadout, v)
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(SwatJob.GestionSaisiesMenu, true, true, true, function()

                    if not next(SwatJob.saisies) then
                        RageUI.ButtonWithStyle("~r~Aucune saisies", nil, { RightLabel = "" }, false, function(Hovered, Active, Selected)
                        end)
                    else
                        for k,v in pairs(SwatJob.saisies) do
                            RageUI.ButtonWithStyle(v.appartenance, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SwatJob.selectedSaisie = {
                                        id = v.id,
                                        appartenance = v.appartenance,
                                        motif = v.motif,
                                        items = v.items,
                                        weapons = v.weapons
                                    }
                                end
                            end, SwatJob.SelectedSaisieMenu)
                        end
                    end

                end)

                RageUI.IsVisible(SwatJob.SelectedSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance: ~g~"..SwatJob.selectedSaisie.appartenance, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    RageUI.ButtonWithStyle("Motif: ~b~"..SwatJob.selectedSaisie.motif, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    if Framework.PlayerData.jobs['job'].grade >= 8 then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Modifier la saisie", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, SwatJob.EditSaisieMenu)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SwatJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, nil, { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                    for k,v in pairs(SwatJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, nil, { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(SwatJob.EditSaisieMenu, true, true, true, function()

                    RageUI.Separator("↓ Modification ↓")

                    RageUI.ButtonWithStyle("Appartenance", "Appartenance: ~b~"..SwatJob.selectedSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                SwatJob.selectedSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..SwatJob.selectedSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                SwatJob.selectedSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Modifier les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwatJob.editedPlayerData = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            SwatJob.editedPlayerData2 = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            SwatJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("SwatJob:getSaisiePlayerData", function(data) 
                                SwatJob.saisiePlayerData = data
                            end)
                        end
                    end, SwatJob.EditSaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider les modifications", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SwatJob:editSaisie', SwatJob.selectedSaisie, SwatJob.editedPlayerData, SwatJob.editedPlayerData2)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Actions ↓")

                    RageUI.ButtonWithStyle("~r~Supprimer la Saisie", "~r~Vous PERDEREZ tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SwatJob:removeSaisie', SwatJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("~b~Récupérer la Saisie", "~b~Vous allez récupérer tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SwatJob:giveSaisie', SwatJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                end)

                RageUI.IsVisible(SwatJob.EditSaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(SwatJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(SwatJob.selectedSaisie.items) then
                                        table.insert(SwatJob.selectedSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })
                                        table.insert(SwatJob.editedPlayerData.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    else
                                        for k2,v2 in pairs(SwatJob.selectedSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                                table.insert(SwatJob.editedPlayerData.items, {
                                                    itemName = v.itemName,
                                                    itemLabel = v.itemLabel,
                                                    itemCount = tonumber(qte)
                                                })
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(SwatJob.selectedSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                            table.insert(SwatJob.editedPlayerData.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                        end

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~o~Vos Armes~s~ ↓")

                    for k,v in pairs(SwatJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(SwatJob.selectedSaisie.weapons) then
                                    table.insert(SwatJob.selectedSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.insert(SwatJob.editedPlayerData.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })

                                    table.remove(SwatJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(SwatJob.selectedSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                            table.insert(SwatJob.editedPlayerData.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(SwatJob.selectedSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.insert(SwatJob.editedPlayerData.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(SwatJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SwatJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
                                local add = false
                                if tonumber(qte) and v.itemCount >= tonumber(qte) then v.itemCount = v.itemCount - qte end
                                if v.itemCount == 0 then table.remove(SwatJob.selectedSaisie.items, k) end

                                for k2,v2 in pairs(SwatJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        add = true;
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end

                                if not add then
                                    table.insert(SwatJob.saisiePlayerData.inventory, {
                                        itemName = v.itemName,
                                        itemLabel = v.itemLabel,
                                        itemCount = tonumber(qte)
                                    })
                                end
                                table.insert(SwatJob.editedPlayerData2.items, {
                                    itemName = v.itemName,
                                    itemLabel = v.itemLabel,
                                    itemCount = tonumber(qte)
                                })
                            end
                        end)
                    end

                    for k,v in pairs(SwatJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = v.count - 1
                                if v.count == 0 then table.remove(SwatJob.selectedSaisie.weapons, k) end
                                table.insert(SwatJob.saisiePlayerData.loadout, v)
                                table.insert(SwatJob.editedPlayerData2.weapons, v)
                            end
                        end)
                    end

                end)

            end
        end)
    end
end