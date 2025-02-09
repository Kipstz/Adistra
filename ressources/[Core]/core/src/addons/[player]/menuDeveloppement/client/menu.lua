
MenuDev.MainMenu = RageUI.CreateMenu("Menu Développement", "Développé", 8, 200)

MenuDev.ItemsSQL = RageUI.CreateSubMenu(MenuDev.MainMenu, "Menu Développement", "Développé", 8, 200)
MenuDev.JobsSQL = RageUI.CreateSubMenu(MenuDev.MainMenu, "Menu Développement", "Développé", 8, 200)

local open = false

MenuDev.MainMenu.Closed = function()
    open = false
end

MenuDev.OpenDevMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(MenuDev.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(MenuDev.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(MenuDev.MainMenu, true, true, true, function()

                    RageUI.Separator("↓ Developpement Menus ↓")

                    RageUI.ButtonWithStyle("Items create SQL", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            MenuDev.ItemCreating = {
                                name = '',
                                label = '',
                                weight = 0,
                                canRemove = 1
                            }
                        end
                    end, MenuDev.ItemsSQL)

                    RageUI.ButtonWithStyle("Jobs create SQL", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            MenuDev.JobCreating = {
                                name = '',
                                label = '',
                                grades = {}
                            }
                        end
                    end, MenuDev.JobsSQL)

                end)

                RageUI.IsVisible(MenuDev.ItemsSQL, true, true, true, function()

                    RageUI.ButtonWithStyle("Name", nil, { RightLabel = MenuDev.ItemCreating.name }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local name = VisualManager:KeyboardOutput("Name", "", 25)

                            if tostring(name) then
                                MenuDev.ItemCreating.name = name;
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Label", nil, { RightLabel = MenuDev.ItemCreating.label }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local label = VisualManager:KeyboardOutput("Label", "", 25)

                            if tostring(label) then
                                MenuDev.ItemCreating.label = label;
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Weight", nil, { RightLabel = MenuDev.ItemCreating.weight }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local weight = VisualManager:KeyboardOutput("Weight", "", 5)

                            if tonumber(weight) then
                                MenuDev.ItemCreating.weight = (tonumber(weight) + 0.0)
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Can Remove", nil, { RightLabel = MenuDev.ItemCreating.canRemove }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local canRemove = VisualManager:KeyboardOutput("Can Remove", "", 1)

                            if tonumber(canRemove) then
                                MenuDev.ItemCreating.canRemove = tonumber(canRemove)
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Add", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('menudev:addItem', MenuDev.ItemCreating)
                        end
                    end)

                end)

                RageUI.IsVisible(MenuDev.JobsSQL, true, true, true, function()

                    RageUI.Separator("↓ Job ↓")

                    RageUI.ButtonWithStyle("Name", nil, { RightLabel = MenuDev.JobCreating.name }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local name = VisualManager:KeyboardOutput("Name", "", 25)

                            if tostring(name) then
                                MenuDev.JobCreating.name = name;
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end, AdminMenu.JobsSQL)

                    RageUI.ButtonWithStyle("Label", nil, { RightLabel = MenuDev.JobCreating.label }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local label = VisualManager:KeyboardOutput("Label", "", 25)

                            if tostring(label) then
                                MenuDev.JobCreating.label = label;
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end, AdminMenu.JobsSQL)

                    RageUI.Separator("↓ Grades ↓")

                    for k,v in pairs(MenuDev.JobCreating.grades) do
                        RageUI.ButtonWithStyle("Grade N° "..k, "Nom: "..v.name.."\nLabel: "..v.label.."\nGrade: "..v.grade.."", { RightLabel = "~r~Supprimer~s~" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                table.remove(MenuDev.JobCreating.grades, k)
                            end
                        end)
                    end

                    RageUI.Line()
                    
                    RageUI.ButtonWithStyle("Add Grade", nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local name = VisualManager:KeyboardOutput("Name", "", 25)
                            local label = VisualManager:KeyboardOutput("Label", "", 25)
                            local grade = VisualManager:KeyboardOutput("Grade", "", 2)

                            if tostring(name) and tostring(label) and tonumber(grade) then
                                table.insert(MenuDev.JobCreating.grades, {
                                    name = name,
                                    label = label,
                                    grade = grade
                                })
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Add", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('menudev:addJob', MenuDev.JobCreating)
                        end
                    end)

                end)

            end
        end)
    end
end