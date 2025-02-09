SheriffPaletoJob.SaisiesMenu = RageUI.CreateMenu("Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)

SheriffPaletoJob.AddSaisieMenu = RageUI.CreateSubMenu(SheriffPaletoJob.SaisiesMenu, "Sheriff", "~p~Sheriff~s~: Ajouter une Saisie", 8, 200)
SheriffPaletoJob.SaisieInventoryMenu = RageUI.CreateSubMenu(SheriffPaletoJob.AddSaisieMenu, "Sheriff", "~p~Sheriff~s~: Objets de la Saisie", 8, 200)

SheriffPaletoJob.GestionSaisiesMenu = RageUI.CreateSubMenu(SheriffPaletoJob.SaisiesMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)
SheriffPaletoJob.SelectedSaisieMenu = RageUI.CreateSubMenu(SheriffPaletoJob.GestionSaisiesMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)
SheriffPaletoJob.EditSaisieMenu = RageUI.CreateSubMenu(SheriffPaletoJob.SelectedSaisieMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)
SheriffPaletoJob.EditSaisieInventoryMenu = RageUI.CreateSubMenu(SheriffPaletoJob.EditSaisieMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)

local open = false

SheriffPaletoJob.SaisiesMenu.Closed = function()
    open = false
end

SheriffPaletoJob.OpenSaisiesMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SheriffPaletoJob.SaisiesMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SheriffPaletoJob.SaisiesMenu, true)
        open = true

        SheriffPaletoJob.saisies = {}
        SheriffPaletoJob.selectedSaisie = {}

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(SheriffPaletoJob.SaisiesMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter une Saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SheriffPaletoJob.buildSaisie = {
                                appartenance = '',
                                motif = '',
                                accounts = {},
                                items = {},
                                weapons = {},
                            }
                        end
                    end, SheriffPaletoJob.AddSaisieMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Acceder aux Saisies", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('SheriffPaletoJob:getAllSaisies', function(saisies)
                                SheriffPaletoJob.saisies = saisies
                            end)
                        end
                    end, SheriffPaletoJob.GestionSaisiesMenu)
                end)

                RageUI.IsVisible(SheriffPaletoJob.AddSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance", "A qui appartient la saisie (ex: un gang, orga ...etc) \nAppartenance: ~b~"..SheriffPaletoJob.buildSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                SheriffPaletoJob.buildSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..SheriffPaletoJob.buildSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                SheriffPaletoJob.buildSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Déposer les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SheriffPaletoJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("SheriffPaletoJob:getSaisiePlayerData", function(data) 
                                SheriffPaletoJob.saisiePlayerData = data
                            end)
                        end
                    end, SheriffPaletoJob.SaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider la saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if SheriffPaletoJob.buildSaisie.appartenance ~= '' and SheriffPaletoJob.buildSaisie.motif ~= '' then
                                if next(SheriffPaletoJob.buildSaisie.accounts) or next(SheriffPaletoJob.buildSaisie.items) or next(SheriffPaletoJob.buildSaisie.weapons) then
                                    TriggerServerEvent('SheriffPaletoJob:addSaisie', SheriffPaletoJob.buildSaisie)
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

                RageUI.IsVisible(SheriffPaletoJob.SaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(SheriffPaletoJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(SheriffPaletoJob.buildSaisie.items) then
                                        table.insert(SheriffPaletoJob.buildSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = v.itemCount - qte
                                    else
                                        for k2,v2 in pairs(SheriffPaletoJob.buildSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(SheriffPaletoJob.buildSaisie.items, {
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

                    for k,v in pairs(SheriffPaletoJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(SheriffPaletoJob.buildSaisie.weapons) then
                                    table.insert(SheriffPaletoJob.buildSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.remove(SheriffPaletoJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(SheriffPaletoJob.buildSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(SheriffPaletoJob.buildSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(SheriffPaletoJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SheriffPaletoJob.buildSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and tonumber(v.itemCount) >= tonumber(qte) then v.itemCount = tonumber(v.itemCount - qte) end
                                if v.itemCount == 0 then table.remove(SheriffPaletoJob.buildSaisie.items, k) end

                                for k2,v2 in pairs(SheriffPaletoJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end
                            end
                        end)
                    end

                    for k,v in pairs(SheriffPaletoJob.buildSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = tonumber(v.count - 1)
                                if v.count == 0 then table.remove(SheriffPaletoJob.buildSaisie.weapons, k) end
                                table.insert(SheriffPaletoJob.saisiePlayerData.loadout, v)
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(SheriffPaletoJob.GestionSaisiesMenu, true, true, true, function()

                    if not next(SheriffPaletoJob.saisies) then
                        RageUI.ButtonWithStyle("~r~Aucune saisies", nil, { RightLabel = "" }, false, function(Hovered, Active, Selected)
                        end)
                    else
                        for k,v in pairs(SheriffPaletoJob.saisies) do
                            RageUI.ButtonWithStyle(v.appartenance, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SheriffPaletoJob.selectedSaisie = {
                                        id = v.id,
                                        appartenance = v.appartenance,
                                        motif = v.motif,
                                        items = v.items,
                                        weapons = v.weapons
                                    }
                                end
                            end, SheriffPaletoJob.SelectedSaisieMenu)
                        end
                    end

                end)

                RageUI.IsVisible(SheriffPaletoJob.SelectedSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance: ~g~"..SheriffPaletoJob.selectedSaisie.appartenance, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    RageUI.ButtonWithStyle("Motif: ~b~"..SheriffPaletoJob.selectedSaisie.motif, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    if Framework.PlayerData.jobs['job'].grade >= 8 then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Modifier la saisie", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, SheriffPaletoJob.EditSaisieMenu)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SheriffPaletoJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, nil, { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                    for k,v in pairs(SheriffPaletoJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, nil, { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(SheriffPaletoJob.EditSaisieMenu, true, true, true, function()

                    RageUI.Separator("↓ Modification ↓")

                    RageUI.ButtonWithStyle("Appartenance", "Appartenance: ~b~"..SheriffPaletoJob.selectedSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                SheriffPaletoJob.selectedSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..SheriffPaletoJob.selectedSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                SheriffPaletoJob.selectedSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Modifier les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SheriffPaletoJob.editedPlayerData = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            SheriffPaletoJob.editedPlayerData2 = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            SheriffPaletoJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("SheriffPaletoJob:getSaisiePlayerData", function(data) 
                                SheriffPaletoJob.saisiePlayerData = data
                            end)
                        end
                    end, SheriffPaletoJob.EditSaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider les modifications", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SheriffPaletoJob:editSaisie', SheriffPaletoJob.selectedSaisie, SheriffPaletoJob.editedPlayerData, SheriffPaletoJob.editedPlayerData2)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Actions ↓")

                    RageUI.ButtonWithStyle("~r~Supprimer la Saisie", "~r~Vous PERDEREZ tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SheriffPaletoJob:removeSaisie', SheriffPaletoJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("~b~Récupérer la Saisie", "~b~Vous allez récupérer tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SheriffPaletoJob:giveSaisie', SheriffPaletoJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                end)

                RageUI.IsVisible(SheriffPaletoJob.EditSaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(SheriffPaletoJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(SheriffPaletoJob.selectedSaisie.items) then
                                        table.insert(SheriffPaletoJob.selectedSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })
                                        table.insert(SheriffPaletoJob.editedPlayerData.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    else
                                        for k2,v2 in pairs(SheriffPaletoJob.selectedSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                                table.insert(SheriffPaletoJob.editedPlayerData.items, {
                                                    itemName = v.itemName,
                                                    itemLabel = v.itemLabel,
                                                    itemCount = tonumber(qte)
                                                })
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(SheriffPaletoJob.selectedSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                            table.insert(SheriffPaletoJob.editedPlayerData.items, {
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

                    for k,v in pairs(SheriffPaletoJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(SheriffPaletoJob.selectedSaisie.weapons) then
                                    table.insert(SheriffPaletoJob.selectedSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.insert(SheriffPaletoJob.editedPlayerData.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })

                                    table.remove(SheriffPaletoJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(SheriffPaletoJob.selectedSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                            table.insert(SheriffPaletoJob.editedPlayerData.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(SheriffPaletoJob.selectedSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.insert(SheriffPaletoJob.editedPlayerData.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(SheriffPaletoJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SheriffPaletoJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
                                local add = false
                                if tonumber(qte) and v.itemCount >= tonumber(qte) then v.itemCount = v.itemCount - qte end
                                if v.itemCount == 0 then table.remove(SheriffPaletoJob.selectedSaisie.items, k) end

                                for k2,v2 in pairs(SheriffPaletoJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        add = true;
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end

                                if not add then
                                    table.insert(SheriffPaletoJob.saisiePlayerData.inventory, {
                                        itemName = v.itemName,
                                        itemLabel = v.itemLabel,
                                        itemCount = tonumber(qte)
                                    })
                                end
                                table.insert(SheriffPaletoJob.editedPlayerData2.items, {
                                    itemName = v.itemName,
                                    itemLabel = v.itemLabel,
                                    itemCount = tonumber(qte)
                                })
                            end
                        end)
                    end

                    for k,v in pairs(SheriffPaletoJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = v.count - 1
                                if v.count == 0 then table.remove(SheriffPaletoJob.selectedSaisie.weapons, k) end
                                table.insert(SheriffPaletoJob.saisiePlayerData.loadout, v)
                                table.insert(SheriffPaletoJob.editedPlayerData2.weapons, v)
                            end
                        end)
                    end

                end)

            end
        end)
    end
end