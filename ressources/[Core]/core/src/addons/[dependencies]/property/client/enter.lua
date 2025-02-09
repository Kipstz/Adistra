
Property.enterMenu = RageUI.CreateMenu("Entrée", "~p~Entrée~s~: Actions", 8, 200)

local open = false

Property.enterMenu.Closed = function()
    open = false
end

function Property:openEnterMenu(id)
    local property = Property:getPropertybyId(id)
    local owned = Property:isOwnedbyId(property)

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.enterMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.enterMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.enterMenu, true, true, true, function()

                    RageUI.Separator("Id de propriété: ~b~"..property.id.."")

                    if not owned then
                        RageUI.ButtonWithStyle("~g~Acheter: ","~r~Contacter un Agent Immobilier pour Acheter cette Propriete", { RightLabel = "~g~"..Framework.Math.GroupDigits(property.params.priceVente).." $" }, true, function(Hovered, Active, Selected)
                        end)
    
                        RageUI.ButtonWithStyle("~g~Louer: ","~r~Contacter un Agent Immobilier pour Louer cette Propriete", { RightLabel = "~g~"..Framework.Math.GroupDigits(property.params.priceLoc).." $" }, true, function(Hovered, Active, Selected)
                        end)

                        -- RageUI.Line()

                        -- RageUI.ButtonWithStyle("Visiter",nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        --     if Selected then
                        --         RageUI.CloseAll()
                        --         Property:VisiteProperty(id)
                        --     end
                        -- end)
                    else
                        RageUI.ButtonWithStyle("Sonner à la Porte",nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                Framework.ShowNotification("~g~Vous avez Sonner !~s~")

                                Framework.TriggerServerCallback('framework:Onesync:getPlayersInArea', function(playersInArea)
                                    for i=1, #playersInArea, 1 do
                                        if playersInArea[i].id ~= GetPlayerServerId(PlayerId()) then
                                            TriggerServerEvent("property:sonne", playersInArea[i].id)
                                        end
                                    end
                                end, vector3(property.points.exit.x, property.points.exit.y, property.points.exit.z), 25.0)
                            end
                        end)
                    end

                end)
            end
        end)
    end
end

Property.enterMenu2 = RageUI.CreateMenu("Entrée", "~p~Entrée~s~: Actions", 8, 200)

local open = false

Property.enterMenu2.Closed = function()
    open = false
end

function Property:openEnterMenu2(id)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.enterMenu2, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.enterMenu2, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.enterMenu2, true, true, true, function()

                    RageUI.ButtonWithStyle("Entrée dans la Propriété",nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            TriggerEvent('instance:create', 'property', {property = id, instanceId = id})
                        end
                    end)

                end)
            end
        end)
    end
end

function Property:enter(id)
    local property = Property:getPropertybyId(id)
    if property and property.points and property.points.exit and property.points.exit.x then
        local plyPed = PlayerPedId()
        Property.inPropertyId = id;
        -- local ipl = GetIpls(propriete.Interieur)
    
        for k,v in pairs(Property.properties) do
            if tonumber(v.id) ~= tonumber(id) then v.disabled = true end
        end
    
        for k,v in pairs(Property.owneds) do
            if tonumber(v.id) ~= tonumber(id) then v.disabled = true end
        end
    
        TriggerServerEvent("property:saveLastProperty", id)
    
    
        CreateThread(function()
            DoScreenFadeOut(800)
    
            -- while not IsScreenFadedOut() do Wait(100) end
            -- if ipl ~= nil then
            --     RequestIpl(ipl)
            --     while not IsIplActive(ipl) do Wait(100) end
            -- end
    
            SetEntityCoords(plyPed, property.points.exit.x, property.points.exit.y, property.points.exit.z)
            DoScreenFadeIn(800)
        end)
    end
end