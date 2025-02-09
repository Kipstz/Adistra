
PaletoGarageJob.HarvestMenu = RageUI.CreateMenu("Paleto Garage", "~p~Paleto Garage~s~: Récupération de pièces", 8, 200)

local open = false

PaletoGarageJob.HarvestMenu.Closed = function()
    open = false
end

PaletoGarageJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PaletoGarageJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PaletoGarageJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PaletoGarageJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_paletogarage'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                PaletoGarageJob.startHarvest(v.name, v.price, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

PaletoGarageJob.startHarvest = function(type, price, msg, anim)
    if not PaletoGarageJob.inHarvest then
        PaletoGarageJob.inHarvest = true;

        exports["ac"]:ExecuteServerEvent("PaletoGarageJob:startHarvest", type, price)
    
        PaletoGarageJob:progress(msg, anim)
    end
end

RegisterNetEvent('PaletoGarageJob:stopHarvest')
AddEventHandler('PaletoGarageJob:stopHarvest', function()
    PaletoGarageJob.inHarvest = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)