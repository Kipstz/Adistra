
CookiesJob.CraftMenu = RageUI.CreateMenu("BurgerShot", "~p~BurgerShot~s~: Craft", 8, 200)

local open = false

CookiesJob.CraftMenu.Closed = function()
    open = false
end

CookiesJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CookiesJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cookies'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                CookiesJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

CookiesJob.startCraft = function(need, type, msg)
    CookiesJob.canNotif = true;

    if not CookiesJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    CookiesJob.canNotif = false;
                    CookiesJob.inCraft = true;
    
                    exports["ac"]:ExecuteServerEvent("CookiesJob:startCraft", need, type)
                
                    CookiesJob:progress(msg, anim)
                else
                    CookiesJob.canNotif = false;
                    CookiesJob.canCraft = false;
                    Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
    
                    return
                end
            end
        end

        if CookiesJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
        end
    end
end

RegisterNetEvent('CookiesJob:stopCraft')
AddEventHandler('CookiesJob:stopCraft', function()
    CookiesJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)