
TequilalaJob.CraftMenu = RageUI.CreateMenu("Tequi-la-la", "~p~Tequi-la-la~s~: Craft", 8, 200)

local open = false

TequilalaJob.CraftMenu.Closed = function()
    open = false
end

TequilalaJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(TequilalaJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(TequilalaJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(TequilalaJob.CraftMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Contacter le Fournisseur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.ShowAdvancedNotification("Tequi-la-la", "~p~Fournisseur", "Salut ! ~n~Si tu veux venir me voir, je t'es mis un point GPS sur ta carte !")
                            SetNewWaypoint(Config['job_tequilala'].Points.harvest.pos)
                        end
                    end)

                    RageUI.Line()

                    for k,v in pairs(Config['job_tequilala'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, v.desc, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TequilalaJob.startCraft(v.needs, v.name)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

TequilalaJob.startCraft = function(needs, item)
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

    TriggerServerEvent("TequilalaJob:craft", needs, item)
end
