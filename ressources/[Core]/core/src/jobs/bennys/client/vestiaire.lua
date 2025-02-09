BennysJob.VestiaireMenu = RageUI.CreateMenu("Benny's", "~p~Benny's~s~: Vestiaire", 8, 200)

local open = false

BennysJob.VestiaireMenu.Closed = function()
    open = false
end

BennysJob.OpenVestiaireMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.VestiaireMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.VestiaireMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(BennysJob.VestiaireMenu, true, true, true, function()

                    RageUI.Separator("↓   Tenue Civil   ↓")

                    RageUI.ButtonWithStyle("Reprendre votre tenue Civil", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    RageUI.Separator("↓   Tenues   ↓")

                    for k,v in pairs(Config['job_bennys'].Tenues) do
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

                    RageUI.Separator("↓   Sacs   ↓")

                    for k,v in pairs(Config['job_bennys'].Sacs) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                    if skin.sex == 0 then
                                        for k,v in pairs(v.skin.m) do
                                            TriggerEvent('skinchanger:change', k, v)
                                            if k == 'bags_1' then TriggerServerEvent('skinchanger:setWeight', v) end
                                        end
                                    else
                                        for k,v in pairs(v.skin.f) do
                                            TriggerEvent('skinchanger:change', k, v)
                                            if k == 'bags_1' then TriggerServerEvent('skinchanger:setWeight', v) end
                                        end
                                    end
                                end)
                            end
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Enlever le Sac", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                if skin.sex == 0 then
                                    TriggerEvent('skinchanger:change', 'bags_1', 0)
                                    TriggerEvent('skinchanger:change', 'bags_2', 0)
                                else
                                    TriggerEvent('skinchanger:change', 'bags_1', 0)
                                    TriggerEvent('skinchanger:change', 'bags_2', 0)
                                end
                            end)

                            TriggerServerEvent('skinchanger:setWeight', 0)
                        end
                    end)
                end)
                
            end
        end)
    end
end