local coords_location = {
    vector3(-1035.5, -2731.2, 13.7),
    vector3(-413.2, 1168.3, 325.9),
    vector3(-1613.0, -1128.7, 2.3),
}

local spawn_coords = nil

local function calcul_distance(coords_player, coords)
    return #(coords_player - coords)
end

local function open_menu(type_menu, coords_player)
    if type_menu == "vehicle" then
        if calcul_distance(coords_player, coords_location[1]) < 10 then
            spawn_coords = vector3(-1019.8, -2731.3, 13.7)
        else
            spawn_coords = vector3(-411.3, 1177.3, 325.6)
        end
    elseif type_menu == "water" then
        spawn_coords = vector3(-1642.6, -1156.4, 1.0)
    end

    LocationMainMenu = RageUI.CreateMenu("Locations", "Choisissez une catégorie", 8, 200)
    local sub_vehiclemenu = RageUI.CreateSubMenu(LocationMainMenu, nil, "Locations")
    local sub_motomenu = RageUI.CreateSubMenu(LocationMainMenu, nil, "Locations")
    local sub_velomenu = RageUI.CreateSubMenu(LocationMainMenu, nil, "Locations")

    RageUI.Visible(LocationMainMenu, not RageUI.Visible(LocationMainMenu))

    while LocationMainMenu do 
        RageUI.IsVisible(LocationMainMenu, true, true, true, function()
            if type_menu == "vehicle" then
                RageUI.ButtonWithStyle("Voitures", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, sub_vehiclemenu)
                RageUI.ButtonWithStyle("Moto", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, sub_motomenu)
                RageUI.ButtonWithStyle("Vélos", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, sub_velomenu)
            else
                RageUI.ButtonWithStyle("Jetski", nil, { RightLabel = "~g~500$" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        if Framework.Game.IsSpawnPointClear(spawn_coords, 5.0) then
                            Framework.TriggerServerCallback("adistraCore.haveMoney", function(hasMoney)
                                if hasMoney then
                                    Framework.Game.SpawnVehicle("seashark3", spawn_coords, 90.0, function(vehicle)
                                        if vehicle then
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                            SetVehicleNumberPlateText(vehicle, "LOCA")
                                            TriggerServerEvent('keys:givekey', 'no', "LOCA")
                                            RageUI.CloseAll()
                                        else
                                            print("Erreur lors du spawn du jetski")
                                        end
                                    end)
                                end
                            end, 500)
                        else
                            Framework.ShowNotification("~r~Il n'y a pas asser de place dans la zone !")
                        end
                    end
                end)
            end
        end)

        RageUI.IsVisible(sub_vehiclemenu, true, true, true, function()
            RageUI.ButtonWithStyle("Blista", nil, {RightLabel = "~g~750$"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    if Framework.Game.IsSpawnPointClear(spawn_coords, 5.0) then
                        Framework.TriggerServerCallback("adistraCore.haveMoney", function(hasMoney)
                            if hasMoney then
                                Framework.Game.SpawnVehicle("blista", spawn_coords, 90.0, function(vehicle)
                                    if vehicle then
                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        SetVehicleNumberPlateText(vehicle, "LOCA")
                                        TriggerServerEvent('keys:givekey', 'no', "LOCA")
                                        RageUI.CloseAll()
                                    else
                                        print("Erreur lors du spawn de la Blista")
                                    end
                                end)
                            end
                        end, 750)
                    else
                        Framework.ShowNotification("~r~Il n'y a pas asser de place dans la zone !")
                    end
                end 
            end)
        end)

        RageUI.IsVisible(sub_motomenu, true, true, true, function()
            RageUI.ButtonWithStyle("Fagio", nil, {RightLabel = "~g~350$"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    if Framework.Game.IsSpawnPointClear(spawn_coords, 5.0) then
                        Framework.TriggerServerCallback("adistraCore.haveMoney", function(hasMoney)
                            if hasMoney then
                                Framework.Game.SpawnVehicle("faggio", spawn_coords, 90.0, function(vehicle)
                                    if vehicle then
                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        SetVehicleNumberPlateText(vehicle, "LOCA")
                                        TriggerServerEvent('keys:givekey', 'no', "LOCA")
                                        RageUI.CloseAll()
                                    else
                                        print("Erreur lors du spawn de la Faggio")
                                    end
                                end)
                            end
                        end, 750)
                    else
                        Framework.ShowNotification("~r~Il n'y a pas asser de place dans la zone !")
                    end
                end 
            end)
        end)

        RageUI.IsVisible(sub_velomenu, true, true, true, function()
            RageUI.ButtonWithStyle("BMX", nil, {RightLabel = "~g~150$"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    if Framework.Game.IsSpawnPointClear(spawn_coords, 5.0) then
                        Framework.TriggerServerCallback("adistraCore.haveMoney", function(hasMoney)
                            if hasMoney then
                                Framework.Game.SpawnVehicle("bmx", spawn_coords, 90.0, function(vehicle)
                                    if vehicle then
                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        SetVehicleNumberPlateText(vehicle, "LOCA")
                                        TriggerServerEvent('keys:givekey', 'no', "LOCA")
                                        RageUI.CloseAll()
                                    else
                                        print("Erreur lors du spawn du BMX")
                                    end
                                end)
                            end
                        end, 750)
                    else
                        Framework.ShowNotification("~r~Il n'y a pas asser de place dans la zone !")
                    end
                end 
            end)
        end)

        if not RageUI.Visible(LocationMainMenu) and not RageUI.Visible(sub_vehiclemenu) and not RageUI.Visible(sub_motomenu) and not RageUI.Visible(sub_velomenu) then 
            LocationMainMenu = RMenu:DeleteType(LocationMainMenu, true)
        end
        Wait(1)
    end
end

local function create_marker(self)
    local coords_player = GetEntityCoords(PlayerPedId())
    DrawMarker(27, self.coords.x, self.coords.y, self.coords.z - 0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    Framework.Game.Utils.DrawText3D((vector3(self.coords.x, self.coords.y, self.coords.z)), "Appuyez sur [~p~E~s~] pour intéragir.", 0.9, 4)

    if self.currentDistance < 3 then
        if IsControlJustPressed(1, 51) then
            if calcul_distance(coords_player, coords_location[3]) < 10 then
                open_menu("water", coords_player)
            else
                open_menu("vehicle", coords_player)
            end
        end
    end
end

local function loading_marker()
    for i = 1, #coords_location do
        lib.points.new({
            coords = coords_location[i],
            distance = 10,
            nearby = create_marker
        })
    end
end

Citizen.CreateThread(function()
    loading_marker()
end)
