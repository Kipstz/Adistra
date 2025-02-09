
-- BASE SERVICE MENU --

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
	while xPlayer.jobs['job'] == nil do
        Wait(10)
    end

    for k,v in pairs(Config['jobcenter']['points']) do
        if xPlayer.jobs['job'].name == v.jobRequired then
            BlipManager:addBlip('baseService_'..k, v['base']['blip'].pos, v['base']['blip'].sprite, v['base']['blip'].color, v['base']['blip'].label, 0.7, true)
        end
    end
end)

RegisterNetEvent('framework:setJob')
AddEventHandler('framework:setJob', function(job)
    for k,v in pairs(Config['jobcenter']['points']) do
        if job.name == v.jobRequired then
            BlipManager:removeBlip('baseService_'..k)
            BlipManager:addBlip('baseService_'..k, v['base']['blip'].pos, v['base']['blip'].sprite, v['base']['blip'].color, v['base']['blip'].label, 0.7, true)
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config['jobcenter']['points']) do
        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
            BlipManager:addBlip('baseService_'..k, v['base']['blip'].pos, v['base']['blip'].sprite, v['base']['blip'].color, v['base']['blip'].label, 0.7, true)
        end
        
        EntityManager:createPed(v['base'].pedModel, v['base'].pos, v['base'].pedHeading)
        ZoneManager:createZoneWithMarker(v['base'].pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                    JobCenter:OpenServiceMenu(v.jobRequired, v.jobLabel)
                else
                    Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cela !~s~")
                end
            end}
        })
    end
end)

JobCenter.ServiceMenu = RageUI.CreateMenu("Pôle-Emploi", "Que souhaitez-vous faire ?", 8, 200)

local open = false

JobCenter.ServiceMenu.Closed = function()
    open = false
end

JobCenter.ServiceCheck = false

function JobCenter:OpenServiceMenu(job, jobLabel)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(JobCenter.ServiceMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(JobCenter.ServiceMenu, true)
        open = true

        JobCenter.ServiceMenu:SetTitle(jobLabel)

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(JobCenter.ServiceMenu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, JobCenter.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            JobCenter.ServiceCheck = Checked

                            if Checked then
                                JobCenter:Service(JobCenter.ServiceCheck, job)
                                Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                    if skin.sex == 0 then
                                        for k,v in pairs(Config['jobcenter']['points'][job]['base'].tenue.skin.m) do
                                            TriggerEvent('skinchanger:change', k, v)
                                            if k == 'bags_1' then TriggerServerEvent('skinchanger:setWeight', v) end
                                        end
                                    else
                                        for k,v in pairs(Config['jobcenter']['points'][job]['base'].tenue.skin.f) do
                                            TriggerEvent('skinchanger:change', k, v)
                                            if k == 'bags_1' then TriggerServerEvent('skinchanger:setWeight', v) end
                                        end
                                    end
                                end)
                                Framework.ShowNotification("~g~Vous avez pris votre service !~s~")
                            else
                                JobCenter:Service(JobCenter.ServiceCheck)
                                Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                    TriggerServerEvent('skinchanger:setWeight', 0)
                                end)
                                Framework.ShowNotification("~g~Vous n'êtes plus en service !~s~")
                            end
                        end
                    end)
                end)
            end
        end)
    end
end

-- BASE GARAGE MENU --

CreateThread(function()
    for k,v in pairs(Config['jobcenter']['points']) do
        ZoneManager:createZoneWithMarker(v['base']['garage'].pos, 20, 1.5, {
            onPress = {control = 38, action = function(zone)
                if JobCenter.ServiceCheck then
                    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                        JobCenter:OpenGarageMenu(v.jobRequired, v.jobLabel)
                    else
                        Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cela !~s~")
                    end
                else
                    Framework.ShowNotification("~r~Vous n'êtes pas en service !~s~")
                end
            end}
        })
        ZoneManager:createZoneWithMarker(v['base']['garage'].deleters, 10, 3.5, {
            onPress = {control = 38, action = function(zone)
                if JobCenter.ServiceCheck then
                    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                        v['base']['garage'].action()
                    else
                        Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cela !~s~")
                    end
                else
                    Framework.ShowNotification("~r~Vous n'êtes pas en service !~s~")
                end
            end}
        })
    end
end)

JobCenter.GarageMenu = RageUI.CreateMenu("Pôle-Emploi", "Que souhaitez-vous faire ?", 8, 200)

local open = false

JobCenter.GarageMenu.Closed = function()
    open = false
end

function JobCenter:OpenGarageMenu(job, jobLabel)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(JobCenter.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(JobCenter.GarageMenu, true)
        open = true

        JobCenter.GarageMenu:SetTitle(jobLabel)

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(JobCenter.GarageMenu, true, true, true, function()

                    for k,v in pairs(Config['jobcenter']['points'][job]['base']['garage'].vehicules) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                JobCenter:SpawnVehicule(job, v.name)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end