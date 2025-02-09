
VigneronJob.HarvestMenu = RageUI.CreateMenu("Vigneron", "~p~Vigneron~s~: Récupération de raisins", 8, 200)

local open = false

VigneronJob.HarvestMenu.Closed = function()
    open = false
end

VigneronJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(VigneronJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_vigneron'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, "[~r~E~s~] pour arrêter", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                VigneronJob.startHarvest(v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

VigneronJob.startHarvest = function(type, msg)
    if not VigneronJob.inHarvest then
        VigneronJob.inHarvest = true

        exports["ac"]:ExecuteServerEvent('VigneronJob:startHarvest', type)
        VigneronJob:progress(msg)
    end
end

RegisterNetEvent('VigneronJob:stopHarvest')
AddEventHandler('VigneronJob:stopHarvest', function()
    VigneronJob.inHarvest = false
    FreezeEntityPosition(PlayerPedId(), false)
end)