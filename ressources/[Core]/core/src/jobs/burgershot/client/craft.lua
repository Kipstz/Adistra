
BurgerShotJob.CraftMenu = RageUI.CreateMenu("BurgerShot", "~p~BurgerShot~s~: Craft", 8, 200)

local open = false

BurgerShotJob.CraftMenu.Closed = function()
    open = false
end

BurgerShotJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BurgerShotJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BurgerShotJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(BurgerShotJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_burger'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                BurgerShotJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

BurgerShotJob.startCraft = function(need, type, msg)
    BurgerShotJob.canNotif = true;

    if not BurgerShotJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    BurgerShotJob.canNotif = false;
                    BurgerShotJob.inCraft = true;
    
                    exports["ac"]:ExecuteServerEvent("BurgerShotJob:startCraft", need, type)
                
                    BurgerShotJob:progress(msg, anim)
                else
                    BurgerShotJob.canNotif = false;
                    BurgerShotJob.canCraft = false;
                    Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
    
                    return
                end
            end
        end

        if BurgerShotJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
        end
    end
end

RegisterNetEvent('BurgerShotJob:stopCraft')
AddEventHandler('BurgerShotJob:stopCraft', function()
    BurgerShotJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)