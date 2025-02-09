
MecanoJob.HarvestMenu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Récupération de pièces", 8, 200)

local open = false

MecanoJob.HarvestMenu.Closed = function()
    open = false
end

MecanoJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(MecanoJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(MecanoJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(MecanoJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_mecano'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                MecanoJob.startHarvest(v.name, v.price, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

MecanoJob.startHarvest = function(type, price, msg, anim)
    if not MecanoJob.inHarvest then
        MecanoJob.inHarvest = true;

        exports["ac"]:ExecuteServerEvent("MecanoJob:startHarvest", type, price)
    
        MecanoJob:progress(msg, anim)
    end
end

RegisterNetEvent('MecanoJob:stopHarvest')
AddEventHandler('MecanoJob:stopHarvest', function()
    MecanoJob.inHarvest = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)