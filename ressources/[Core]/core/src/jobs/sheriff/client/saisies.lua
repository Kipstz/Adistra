SheriffJob.SaisiesMenu = RageUI.CreateMenu("Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)

SheriffJob.AddSaisieMenu = RageUI.CreateSubMenu(SheriffJob.SaisiesMenu, "Sheriff", "~p~Sheriff~s~: Ajouter une Saisie", 8, 200)
SheriffJob.SaisieInventoryMenu = RageUI.CreateSubMenu(SheriffJob.AddSaisieMenu, "Sheriff", "~p~Sheriff~s~: Objets de la Saisie", 8, 200)

SheriffJob.GestionSaisiesMenu = RageUI.CreateSubMenu(SheriffJob.SaisiesMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)
SheriffJob.SelectedSaisieMenu = RageUI.CreateSubMenu(SheriffJob.GestionSaisiesMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)
SheriffJob.EditSaisieMenu = RageUI.CreateSubMenu(SheriffJob.SelectedSaisieMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)
SheriffJob.EditSaisieInventoryMenu = RageUI.CreateSubMenu(SheriffJob.EditSaisieMenu, "Sheriff", "~p~Sheriff~s~: Saisies", 8, 200)

local open = false

SheriffJob.SaisiesMenu.Closed = function()
    open = false
end

SheriffJob.OpenSaisiesMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SheriffJob.SaisiesMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SheriffJob.SaisiesMenu, true)
        open = true

        SheriffJob.saisies = {}
        SheriffJob.selectedSaisie = {}

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(SheriffJob.SaisiesMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter une Saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SheriffJob.buildSaisie = {
                                appartenance = '',
                                motif = '',
                                accounts = {},
                                items = {},
                                weapons = {},
                            }
                        end
                    end, SheriffJob.AddSaisieMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Acceder aux Saisies", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('SheriffJob:getAllSaisies', function(saisies)
                                SheriffJob.saisies = saisies
                            end)
                        end
                    end, SheriffJob.GestionSaisiesMenu)
                end)

                RageUI.IsVisible(SheriffJob.AddSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance", "A qui appartient la saisie (ex: un gang, orga ...etc) \nAppartenance: ~b~"..SheriffJob.buildSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                SheriffJob.buildSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..SheriffJob.buildSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                SheriffJob.buildSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Déposer les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SheriffJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("SheriffJob:getSaisiePlayerData", function(data) 
                                SheriffJob.saisiePlayerData = data
                            end)
                        end
                    end, SheriffJob.SaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider la saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if SheriffJob.buildSaisie.appartenance ~= '' and SheriffJob.buildSaisie.motif ~= '' then
                                if next(SheriffJob.buildSaisie.accounts) or next(SheriffJob.buildSaisie.items) or next(SheriffJob.buildSaisie.weapons) then
                                    TriggerServerEvent('SheriffJob:addSaisie', SheriffJob.buildSaisie)
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

                RageUI.IsVisible(SheriffJob.SaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(SheriffJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(SheriffJob.buildSaisie.items) then
                                        table.insert(SheriffJob.buildSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = v.itemCount - qte
                                    else
                                        for k2,v2 in pairs(SheriffJob.buildSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(SheriffJob.buildSaisie.items, {
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

                    for k,v in pairs(SheriffJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(SheriffJob.buildSaisie.weapons) then
                                    table.insert(SheriffJob.buildSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.remove(SheriffJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(SheriffJob.buildSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(SheriffJob.buildSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(SheriffJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SheriffJob.buildSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and tonumber(v.itemCount) >= tonumber(qte) then v.itemCount = tonumber(v.itemCount - qte) end
                                if v.itemCount == 0 then table.remove(SheriffJob.buildSaisie.items, k) end

                                for k2,v2 in pairs(SheriffJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end
                            end
                        end)
                    end

                    for k,v in pairs(SheriffJob.buildSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = tonumber(v.count - 1)
                                if v.count == 0 then table.remove(SheriffJob.buildSaisie.weapons, k) end
                                table.insert(SheriffJob.saisiePlayerData.loadout, v)
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(SheriffJob.GestionSaisiesMenu, true, true, true, function()

                    if not next(SheriffJob.saisies) then
                        RageUI.ButtonWithStyle("~r~Aucune saisies", nil, { RightLabel = "" }, false, function(Hovered, Active, Selected)
                        end)
                    else
                        for k,v in pairs(SheriffJob.saisies) do
                            RageUI.ButtonWithStyle(v.appartenance, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SheriffJob.selectedSaisie = {
                                        id = v.id,
                                        appartenance = v.appartenance,
                                        motif = v.motif,
                                        items = v.items,
                                        weapons = v.weapons
                                    }
                                end
                            end, SheriffJob.SelectedSaisieMenu)
                        end
                    end

                end)

                RageUI.IsVisible(SheriffJob.SelectedSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance: ~g~"..SheriffJob.selectedSaisie.appartenance, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    RageUI.ButtonWithStyle("Motif: ~b~"..SheriffJob.selectedSaisie.motif, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    if Framework.PlayerData.jobs['job'].grade >= 8 then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Modifier la saisie", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, SheriffJob.EditSaisieMenu)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SheriffJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, nil, { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                    for k,v in pairs(SheriffJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, nil, { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(SheriffJob.EditSaisieMenu, true, true, true, function()

                    RageUI.Separator("↓ Modification ↓")

                    RageUI.ButtonWithStyle("Appartenance", "Appartenance: ~b~"..SheriffJob.selectedSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                SheriffJob.selectedSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..SheriffJob.selectedSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                SheriffJob.selectedSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Modifier les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SheriffJob.editedPlayerData = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            SheriffJob.editedPlayerData2 = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            SheriffJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("SheriffJob:getSaisiePlayerData", function(data) 
                                SheriffJob.saisiePlayerData = data
                            end)
                        end
                    end, SheriffJob.EditSaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider les modifications", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SheriffJob:editSaisie', SheriffJob.selectedSaisie, SheriffJob.editedPlayerData, SheriffJob.editedPlayerData2)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Actions ↓")

                    RageUI.ButtonWithStyle("~r~Supprimer la Saisie", "~r~Vous PERDEREZ tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SheriffJob:removeSaisie', SheriffJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("~b~Récupérer la Saisie", "~b~Vous allez récupérer tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('SheriffJob:giveSaisie', SheriffJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                end)

                RageUI.IsVisible(SheriffJob.EditSaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(SheriffJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(SheriffJob.selectedSaisie.items) then
                                        table.insert(SheriffJob.selectedSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })
                                        table.insert(SheriffJob.editedPlayerData.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    else
                                        for k2,v2 in pairs(SheriffJob.selectedSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                                table.insert(SheriffJob.editedPlayerData.items, {
                                                    itemName = v.itemName,
                                                    itemLabel = v.itemLabel,
                                                    itemCount = tonumber(qte)
                                                })
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(SheriffJob.selectedSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                            table.insert(SheriffJob.editedPlayerData.items, {
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

                    for k,v in pairs(SheriffJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(SheriffJob.selectedSaisie.weapons) then
                                    table.insert(SheriffJob.selectedSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.insert(SheriffJob.editedPlayerData.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })

                                    table.remove(SheriffJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(SheriffJob.selectedSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                            table.insert(SheriffJob.editedPlayerData.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(SheriffJob.selectedSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.insert(SheriffJob.editedPlayerData.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(SheriffJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(SheriffJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
                                local add = false
                                if tonumber(qte) and v.itemCount >= tonumber(qte) then v.itemCount = v.itemCount - qte end
                                if v.itemCount == 0 then table.remove(SheriffJob.selectedSaisie.items, k) end

                                for k2,v2 in pairs(SheriffJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        add = true;
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end

                                if not add then
                                    table.insert(SheriffJob.saisiePlayerData.inventory, {
                                        itemName = v.itemName,
                                        itemLabel = v.itemLabel,
                                        itemCount = tonumber(qte)
                                    })
                                end
                                table.insert(SheriffJob.editedPlayerData2.items, {
                                    itemName = v.itemName,
                                    itemLabel = v.itemLabel,
                                    itemCount = tonumber(qte)
                                })
                            end
                        end)
                    end

                    for k,v in pairs(SheriffJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = v.count - 1
                                if v.count == 0 then table.remove(SheriffJob.selectedSaisie.weapons, k) end
                                table.insert(SheriffJob.saisiePlayerData.loadout, v)
                                table.insert(SheriffJob.editedPlayerData2.weapons, v)
                            end
                        end)
                    end

                end)

            end
        end)
    end
end