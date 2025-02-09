
BennysJob.HarvestMenu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Récupération de pièces", 8, 200)

local open = false

BennysJob.HarvestMenu.Closed = function()
    open = false
end

BennysJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(BennysJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_bennys'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                BennysJob.startHarvest(v.name, v.price, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

BennysJob.startHarvest = function(type, price, msg, anim)
    if not BennysJob.inHarvest then
        BennysJob.inHarvest = true

        exports["ac"]:ExecuteServerEvent("BennysJob:startHarvest", type, price)
    
        BennysJob:progress(msg, anim)
    end
end

RegisterNetEvent('BennysJob:stopHarvest')
AddEventHandler('BennysJob:stopHarvest', function()
    BennysJob.inHarvest = false
    FreezeEntityPosition(PlayerPedId(), false)
end)