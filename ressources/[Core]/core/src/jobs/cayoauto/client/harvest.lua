
CayoAutoJob.HarvestMenu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Récupération de pièces", 8, 200)

local open = false

CayoAutoJob.HarvestMenu.Closed = function()
    open = false
end

CayoAutoJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CayoAutoJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cayoauto'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                CayoAutoJob.startHarvest(v.name, v.price, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

CayoAutoJob.startHarvest = function(type, price, msg, anim)
    if not CayoAutoJob.inHarvest then
        CayoAutoJob.inHarvest = true

        exports["ac"]:ExecuteServerEvent("CayoAutoJob:startHarvest", type, price)
    
        CayoAutoJob:progress(msg, anim)
    end
end

RegisterNetEvent('CayoAutoJob:stopHarvest')
AddEventHandler('CayoAutoJob:stopHarvest', function()
    CayoAutoJob.inHarvest = false
    FreezeEntityPosition(PlayerPedId(), false)
end)