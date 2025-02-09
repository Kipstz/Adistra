NightClub.VestiaireMenu = RageUI.CreateMenu("77-Club", "~p~77-Club~s~: Vestiaire", 8, 200)

local open = false

NightClub.VestiaireMenu.Closed = function()
    open = false
end

NightClub.OpenVestiaireMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(NightClub.VestiaireMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(NightClub.VestiaireMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(NightClub.VestiaireMenu, true, true, true, function()

                    RageUI.Separator("↓   Tenue Civil   ↓")

                    RageUI.ButtonWithStyle("Reprendre votre tenue Civil", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    RageUI.Separator("↓   Tenues   ↓")

                    for k,v in pairs(Config['job_77club'].Tenues) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                    if skin.sex == 0 then
                                        for k,v in pairs(v.skin.m) do
                                            TriggerEvent('skinchanger:change', k, v)
                                        end
                                    else
                                        for k,v in pairs(v.skin.f) do
                                            TriggerEvent('skinchanger:change', k, v)
                                        end
                                    end
                                end)
                            end
                        end)
                    end

                end)
                
            end
        end)
    end
end