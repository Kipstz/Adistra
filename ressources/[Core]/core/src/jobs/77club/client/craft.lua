
NightClub.CraftMenu = RageUI.CreateMenu("77-Club", "~p~77-Club~s~: Craft", 8, 200)

local open = false

NightClub.CraftMenu.Closed = function()
    open = false
end

NightClub.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(NightClub.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(NightClub.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(NightClub.CraftMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Contacter le Fournisseur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.ShowAdvancedNotification("77-Club", "~p~Fournisseur", "Salut ! ~n~Si tu veux venir me voir, je t'es mis un point GPS sur ta carte !")
                            SetNewWaypoint(Config['job_77club'].Points.harvest.pos)
                        end
                    end)

                    RageUI.Line()

                    for k,v in pairs(Config['job_77club'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, v.desc, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                NightClub.startCraft(v.needs, v.name)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

NightClub.startCraft = function(needs, item)
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

    TriggerServerEvent("NightClub:craft", needs, item)
end
