FibJob.SaisiesMenu = RageUI.CreateMenu("FIB", "~p~FIB~s~: Saisies", 8, 200)

FibJob.AddSaisieMenu = RageUI.CreateSubMenu(FibJob.SaisiesMenu, "FIB", "~p~FIB~s~: Ajouter une Saisie", 8, 200)
FibJob.SaisieInventoryMenu = RageUI.CreateSubMenu(FibJob.AddSaisieMenu, "FIB", "~p~FIB~s~: Objets de la Saisie", 8, 200)

FibJob.GestionSaisiesMenu = RageUI.CreateSubMenu(FibJob.SaisiesMenu, "FIB", "~p~FIB~s~: Saisies", 8, 200)
FibJob.SelectedSaisieMenu = RageUI.CreateSubMenu(FibJob.GestionSaisiesMenu, "FIB", "~p~FIB~s~: Saisies", 8, 200)
FibJob.EditSaisieMenu = RageUI.CreateSubMenu(FibJob.SelectedSaisieMenu, "FIB", "~p~FIB~s~: Saisies", 8, 200)
FibJob.EditSaisieInventoryMenu = RageUI.CreateSubMenu(FibJob.EditSaisieMenu, "FIB", "~p~FIB~s~: Saisies", 8, 200)

local open = false

FibJob.SaisiesMenu.Closed = function()
    open = false
end

FibJob.OpenSaisiesMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(FibJob.SaisiesMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(FibJob.SaisiesMenu, true)
        open = true

        FibJob.saisies = {}
        FibJob.selectedSaisie = {}

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(FibJob.SaisiesMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter une Saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            FibJob.buildSaisie = {
                                appartenance = '',
                                motif = '',
                                accounts = {},
                                items = {},
                                weapons = {},
                            }
                        end
                    end, FibJob.AddSaisieMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Acceder aux Saisies", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('FibJob:getAllSaisies', function(saisies)
                                FibJob.saisies = saisies
                            end)
                        end
                    end, FibJob.GestionSaisiesMenu)
                end)

                RageUI.IsVisible(FibJob.AddSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance", "A qui appartient la saisie (ex: un gang, orga ...etc) \nAppartenance: ~b~"..FibJob.buildSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                FibJob.buildSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..FibJob.buildSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                FibJob.buildSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Déposer les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            FibJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("FibJob:getSaisiePlayerData", function(data) 
                                FibJob.saisiePlayerData = data
                            end)
                        end
                    end, FibJob.SaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider la saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if FibJob.buildSaisie.appartenance ~= '' and FibJob.buildSaisie.motif ~= '' then
                                if next(FibJob.buildSaisie.accounts) or next(FibJob.buildSaisie.items) or next(FibJob.buildSaisie.weapons) then
                                    TriggerServerEvent('FibJob:addSaisie', FibJob.buildSaisie)
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

                RageUI.IsVisible(FibJob.SaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(FibJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
                                
                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    print("debug, ", Framework.WeaponisBoutique(v.itemName))
                                    local itemFound = false;
                                    if not next(FibJob.buildSaisie.items) then
                                        table.insert(FibJob.buildSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = v.itemCount - qte
                                    else
                                        for k2,v2 in pairs(FibJob.buildSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(FibJob.buildSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                        end

                                        v.itemCount = v.itemCount - qte
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir une quantité valide ou vous ne pouvez pas déposer cette arme. !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~o~Vos Armes~s~ ↓")

                    for k,v in pairs(FibJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not Framework.WeaponisBoutique(v.name) then
                                    if not next(FibJob.buildSaisie.weapons) then
                                        table.insert(FibJob.buildSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.remove(FibJob.saisiePlayerData.loadout, k)
                                    else
                                        for k2,v2 in pairs(FibJob.buildSaisie.weapons) do
                                            if v.weaponName == v2.weaponName then
                                                weaponFound = true;
                                                v2.count = tonumber(v2.count + 1)
                                            end
                                        end
    
                                        if not weaponFound then
                                            table.insert(FibJob.buildSaisie.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
    
                                        table.remove(FibJob.saisiePlayerData.loadout, k)
                                    end
                                else
                                    Framework.ShowNotification("~r~Vous ne pouvez pas déposer une arme boutique !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(FibJob.buildSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and tonumber(v.itemCount) >= tonumber(qte) then v.itemCount = tonumber(v.itemCount - qte) end
                                if v.itemCount == 0 then table.remove(FibJob.buildSaisie.items, k) end
                                
                                for k2,v2 in pairs(FibJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end
                            end
                        end)
                    end

                    for k,v in pairs(FibJob.buildSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = tonumber(v.count - 1)
                                if v.count == 0 then table.remove(FibJob.buildSaisie.weapons, k) end
                                table.insert(FibJob.saisiePlayerData.loadout, v)
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(FibJob.GestionSaisiesMenu, true, true, true, function()

                    if not next(FibJob.saisies) then
                        RageUI.ButtonWithStyle("~r~Aucune saisies", nil, { RightLabel = "" }, false, function(Hovered, Active, Selected)
                        end)
                    else
                        for k,v in pairs(FibJob.saisies) do
                            RageUI.ButtonWithStyle(v.appartenance, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    FibJob.selectedSaisie = {
                                        id = v.id,
                                        appartenance = v.appartenance,
                                        motif = v.motif,
                                        items = v.items,
                                        weapons = v.weapons
                                    }
                                end
                            end, FibJob.SelectedSaisieMenu)
                        end
                    end

                end)

                RageUI.IsVisible(FibJob.SelectedSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance: ~g~"..FibJob.selectedSaisie.appartenance, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    RageUI.ButtonWithStyle("Motif: ~b~"..FibJob.selectedSaisie.motif, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    if Framework.PlayerData.jobs['job'].grade >= 8 then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Modifier la saisie", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, FibJob.EditSaisieMenu)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(FibJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, nil, { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                    for k,v in pairs(FibJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, nil, { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(FibJob.EditSaisieMenu, true, true, true, function()

                    RageUI.Separator("↓ Modification ↓")

                    RageUI.ButtonWithStyle("Appartenance", "Appartenance: ~b~"..FibJob.selectedSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                FibJob.selectedSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..FibJob.selectedSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                FibJob.selectedSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Modifier les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            FibJob.editedPlayerData = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            FibJob.editedPlayerData2 = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            FibJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("FibJob:getSaisiePlayerData", function(data) 
                                FibJob.saisiePlayerData = data
                            end)
                        end
                    end, FibJob.EditSaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider les modifications", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('FibJob:editSaisie', FibJob.selectedSaisie, FibJob.editedPlayerData, FibJob.editedPlayerData2)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Actions ↓")

                    RageUI.ButtonWithStyle("~r~Supprimer la Saisie", "~r~Vous PERDEREZ tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('FibJob:removeSaisie', FibJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("~b~Récupérer la Saisie", "~b~Vous allez récupérer tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('FibJob:giveSaisie', FibJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                end)

                RageUI.IsVisible(FibJob.EditSaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(FibJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(FibJob.selectedSaisie.items) then
                                        table.insert(FibJob.selectedSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })
                                        table.insert(FibJob.editedPlayerData.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    else
                                        for k2,v2 in pairs(FibJob.selectedSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                                table.insert(FibJob.editedPlayerData.items, {
                                                    itemName = v.itemName,
                                                    itemLabel = v.itemLabel,
                                                    itemCount = tonumber(qte)
                                                })
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(FibJob.selectedSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                            table.insert(FibJob.editedPlayerData.items, {
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

                    for k,v in pairs(FibJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(FibJob.selectedSaisie.weapons) then
                                    table.insert(FibJob.selectedSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.insert(FibJob.editedPlayerData.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })

                                    table.remove(FibJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(FibJob.selectedSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                            table.insert(FibJob.editedPlayerData.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(FibJob.selectedSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.insert(FibJob.editedPlayerData.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(FibJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(FibJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
                                local add = false
                                if tonumber(qte) and v.itemCount >= tonumber(qte) then v.itemCount = v.itemCount - qte end
                                if v.itemCount == 0 then table.remove(FibJob.selectedSaisie.items, k) end

                                for k2,v2 in pairs(FibJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        add = true;
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end

                                if not add then
                                    table.insert(FibJob.saisiePlayerData.inventory, {
                                        itemName = v.itemName,
                                        itemLabel = v.itemLabel,
                                        itemCount = tonumber(qte)
                                    })
                                end
                                table.insert(FibJob.editedPlayerData2.items, {
                                    itemName = v.itemName,
                                    itemLabel = v.itemLabel,
                                    itemCount = tonumber(qte)
                                })
                            end
                        end)
                    end

                    for k,v in pairs(FibJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = v.count - 1
                                if v.count == 0 then table.remove(FibJob.selectedSaisie.weapons, k) end
                                table.insert(FibJob.saisiePlayerData.loadout, v)
                                table.insert(FibJob.editedPlayerData2.weapons, v)
                            end
                        end)
                    end

                end)

            end
        end)
    end
end