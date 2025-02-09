
PericoBarJob.CraftMenu = RageUI.CreateMenu("Perico Bar", "~p~Perico Bar~s~: Craft", 8, 200)

local open = false

PericoBarJob.CraftMenu.Closed = function()
    open = false
end

PericoBarJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PericoBarJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PericoBarJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PericoBarJob.CraftMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Contacter le Fournisseur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.ShowAdvancedNotification("Perico Bar", "~p~Fournisseur", "Salut ! ~n~Si tu veux venir me voir, je t'es mis un point GPS sur ta carte !")
                            SetNewWaypoint(Config['job_pericobar'].Points.harvest.pos)
                        end
                    end)

                    RageUI.Line()

                    for k,v in pairs(Config['job_pericobar'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, v.desc, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                PericoBarJob.startCraft(v.needs, v.name)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

PericoBarJob.startCraft = function(needs, item)
    for k,v in pairs(needs) do
        for k2,v2 in pairs(Framework.PlayerData.inventory) do
            if v2.name == v then
                if v2.count < 1 then
                    Framework.ShowNotification("~r~Vous n'avez pas les items requis !")
                    return
                end
            end
        end
    end

    TriggerServerEvent("PericoBarJob:craft", needs, item)
end
