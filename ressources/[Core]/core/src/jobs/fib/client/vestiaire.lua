FibJob.VestiaireMenu = RageUI.CreateMenu("FIB", "~p~FIB~s~: Vestiaire", 8, 200)

local open = false

FibJob.VestiaireMenu.Closed = function()
    open = false
end

FibJob.OpenVestiaireMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(FibJob.VestiaireMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(FibJob.VestiaireMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(FibJob.VestiaireMenu, true, true, true, function()

                    RageUI.Separator("↓   Tenue Civil   ↓")

                    RageUI.ButtonWithStyle("Reprendre votre tenue Civil", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    RageUI.Separator("↓   Tenues   ↓")

                    for k,v in pairs(Config['job_fib'].Tenues) do
                        if Framework.PlayerData.jobs['job'].grade == v.minGrade then
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
                    end

                    RageUI.Separator("↓   Gilets Par Balles   ↓")

                    for k,v in pairs(Config['job_fib'].GPB) do
                        RageUI.ButtonWithStyle("Gilet-Par-Balle", nil, { RightLabel = "~b~"..v.label }, true, function(Hovered, Active, Selected)
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

                                SetPedArmour(PlayerPedId(), 100)
                            end
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Enlever le Gilet", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                if skin.sex == 0 then
                                    TriggerEvent('skinchanger:change', 'bproof_1', 0)
                                    TriggerEvent('skinchanger:change', 'bproof_2', 0)
                                else
                                    TriggerEvent('skinchanger:change', 'bproof_1', 0)
                                    TriggerEvent('skinchanger:change', 'bproof_2', 0)
                                end
                            end)

                            SetPedArmour(PlayerPedId(), 0)
                        end
                    end)

                    RageUI.Separator("↓   Sacs   ↓")

                    for k,v in pairs(Config['job_fib'].Sacs) do
                        RageUI.ButtonWithStyle("Sac", nil, { RightLabel = "~b~"..v.label }, true, function(Hovered, Active, Selected)
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