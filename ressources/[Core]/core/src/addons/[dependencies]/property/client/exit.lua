
Property.exitMenu = RageUI.CreateMenu("Sortie", "~p~Sortie~s~: Actions", 8, 200)

local open = false

Property.exitMenu.Closed = function()
    open = false
end

function Property:openExitMenu(id)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.exitMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.exitMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.exitMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Sortir de la Propriété",nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()

                            TriggerEvent('instance:leave')
                        end
                    end)

                end)
            end
        end)
    end
end

Property.exitMenu2 = RageUI.CreateMenu("Sortie", "~p~Sortie~s~: Actions", 8, 200)
Property.inviteMenu = RageUI.CreateSubMenu(Property.exitMenu2, "Invitations", "~p~Invitations~s~: Liste", 8, 200)

local open = false

Property.exitMenu2.Closed = function()
    open = false
end

function Property:openExitMenu2(id)
    local property = Property:getPropertybyId(id)

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.exitMenu2, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.exitMenu2, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.exitMenu2, true, true, true, function()

                    RageUI.ButtonWithStyle("Sortir de la Propriété",nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()

                            TriggerEvent('instance:leave')
                        end
                    end)

                    RageUI.Line()
    
                    RageUI.ButtonWithStyle("Invité des Joueurs",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PlayersToInvite = {}
                            Framework.TriggerServerCallback('framework:Onesync:getPlayersInArea', function(playersInArea)
                                for i=1, #playersInArea, 1 do
                                    if playersInArea[i].id ~= GetPlayerServerId(PlayerId()) then
                                        table.insert(PlayersToInvite, {label = playersInArea[i].name, value = playersInArea[i].id})
                                    end
                                end
                            end, vector3(property.points.enter.x, property.points.enter.y, property.points.enter.z), 20.0)
                        end
                    end, Property.inviteMenu)
                end)

                RageUI.IsVisible(Property.inviteMenu,true,true,true,function()
                    for k,v in pairs(PlayersToInvite) do
                        RageUI.ButtonWithStyle("~r~"..v.label,nil, { RightLabel = "Invité" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerEvent('instance:invite', 'property', v.value, {property = id, instanceId = id})
                                
                                Framework.ShowNotification("Vous avez invité ~b~"..v.label.."~s~")
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

function Property:exit(id)
    local property = Property:getPropertybyId(id)
    local plyPed   = PlayerPedId()
    Property.inPropertyId = 0;

	for k,v in pairs(Property.properties) do
		if v.id ~= id then
			v.disabled = false;
		end
	end

    for k,v in pairs(Property.owneds) do
		if v.id ~= id then
			v.disabled = false;
		end
	end

    TriggerServerEvent("property:deleteLastProperty")

	CreateThread(function()
		DoScreenFadeOut(800)

		-- while not IsScreenFadedOut() do Wait(1) end
        -- if ipl ~= nil then
        --     RequestIpl(ipl)
        --     while not IsIplActive(ipl) do Wait(1) end
        -- end

		SetEntityCoords(plyPed, property.points.enter.x, property.points.enter.y, property.points.enter.z)
		DoScreenFadeIn(800)
	end)
end