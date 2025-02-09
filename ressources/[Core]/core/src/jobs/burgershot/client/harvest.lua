
BurgerShotJob.HarvestMenu = RageUI.CreateMenu("BurgerShot", "~p~BurgerShot~s~: Récupération D\'ingredients", 8, 200)

local open = false

BurgerShotJob.HarvestMenu.Closed = function()
    open = false
end

BurgerShotJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BurgerShotJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BurgerShotJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(BurgerShotJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_burger'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                BurgerShotJob.startHarvest(v.name, v.price, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

BurgerShotJob.startHarvest = function(type, price, msg, anim)
    if not BurgerShotJob.inHarvest then
        BurgerShotJob.inHarvest = true;

        exports["ac"]:ExecuteServerEvent("BurgerShotJob:startHarvest", type, price)
    
        BurgerShotJob:progress(msg, anim)
    end
end

RegisterNetEvent('BurgerShotJob:stopHarvest')
AddEventHandler('BurgerShotJob:stopHarvest', function()
    BurgerShotJob.inHarvest = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)