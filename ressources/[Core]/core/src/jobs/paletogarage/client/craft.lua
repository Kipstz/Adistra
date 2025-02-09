
PaletoGarageJob.CraftMenu = RageUI.CreateMenu("Paleto Garage", "~p~Paleto Garage~s~: Craft", 8, 200)

local open = false

PaletoGarageJob.CraftMenu.Closed = function()
    open = false
end

PaletoGarageJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PaletoGarageJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PaletoGarageJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PaletoGarageJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_paletogarage'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                PaletoGarageJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

PaletoGarageJob.startCraft = function(need, type, msg)
    PaletoGarageJob.canNotif = true;

    if not PaletoGarageJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    PaletoGarageJob.canNotif = false;
                    PaletoGarageJob.inCraft = true;
    
                    exports["ac"]:ExecuteServerEvent("PaletoGarageJob:startCraft", need, type)
                
                    PaletoGarageJob:progress(msg, anim)
                else
                    PaletoGarageJob.canNotif = false;
                    PaletoGarageJob.canCraft = false;
                    Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
    
                    return
                end
            end
        end

        if PaletoGarageJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
        end
    end
end

RegisterNetEvent('PaletoGarageJob:stopCraft')
AddEventHandler('PaletoGarageJob:stopCraft', function()
    PaletoGarageJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)