
CookiesJob.HarvestMenu = RageUI.CreateMenu("BurgerShot", "~p~BurgerShot~s~: Récupération D\'ingredients", 8, 200)

local open = false

CookiesJob.HarvestMenu.Closed = function()
    open = false
end

CookiesJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CookiesJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cookies'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                CookiesJob.startHarvest(v.name, v.price, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

CookiesJob.startHarvest = function(type, price, msg, anim)
    if not CookiesJob.inHarvest then
        CookiesJob.inHarvest = true;

        exports["ac"]:ExecuteServerEvent("CookiesJob:startHarvest", type, price)
    
        CookiesJob:progress(msg, anim)
    end
end

RegisterNetEvent('CookiesJob:stopHarvest')
AddEventHandler('CookiesJob:stopHarvest', function()
    CookiesJob.inHarvest = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)