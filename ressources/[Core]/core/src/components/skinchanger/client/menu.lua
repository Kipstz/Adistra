SkinMenu = RageUI.CreateMenu("Modification de Personnage", "Modifier votre Personnage !", 8, 200)

SkinchangerMenuIsOpen = false

SkinMenu.Closed = function()
    SkinchangerMenuIsOpen = false
end

SkinChanger.OpenMenu = function()
    local plyPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		SkinChanger.LastSkin = skin
	end)

    if SkinchangerMenuIsOpen then
        RageUI.CloseAll()
        RageUI.Visible(SkinMenu, false)
        SkinchangerMenuIsOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SkinMenu, true)
        SkinchangerMenuIsOpen = true

        SkinMenu.Closable = false

        TriggerEvent('skinchanger:getData', function(components, maxVals)
            local elements = {}
            local _components = {}

            for i = 1, #components, 1 do
                _components[i] = components[i]
            end
    
            for i = 1, #_components, 1 do
                local value = _components[i].value
                local componentId = _components[i].componentId
    
                if componentId == 0 then
                    value = GetPedPropIndex(plyPed, _components[i].componentId)
                end
    
                local data = {
                    label = _components[i].label,
                    name = _components[i].name,
                    value = value,
                    min = _components[i].min,
                    textureof = _components[i].textureof,
                    zoomOffset = _components[i].zoomOffset,
                    camOffset = _components[i].camOffset
                }
    
                for k, v in pairs(maxVals) do
                    if k == _components[i].name then
                        data.max = v
                    end
                end
    
                table.insert(elements, data)
            end

            SkinChanger.CreateSkinCam()

            SkinChanger.zoomOffset = _components[1].zoomOffset
            SkinChanger.camOffset = _components[1].camOffset

            CreateThread(function()
                while SkinchangerMenuIsOpen do
                    Wait(1)
    
                    RageUI.IsVisible(SkinMenu, true, true, true, function()
    
                        for k, v in ipairs(elements) do
                            name = 'skin'

                            v.options = {name = {}}
                            v.max = v.max or 0
                            v.min = v.min or 0
            
                            for i = v.min, v.max, 1 do
                                v.options.name[i] = i
                            end
            
                            if v.options.name[v.min] == nil or v.min == v.max then
                                v.options.name[v.min] = 'Vide'
                            end

                            RageUI.List(v.label, v.options.name, v.value, nil, {}, true, function(Hovered, Active, Selected, Index)
                                if Active then
                                    v.value = Index

                                    SkinChanger.zoomOffset = v.zoomOffset
                                    SkinChanger.camOffset = v.camOffset
                                end
                            end, function(Index)
                                SkinChanger.zoomOffset = v.zoomOffset
                                SkinChanger.camOffset = v.camOffset

                                TriggerEvent('skinchanger:change', v.name, Index)

                                TriggerEvent('skinchanger:getData', function(_, maxVals)
                                    for i = 1, #elements, 1 do
                                        local newData = {}
                                        newData.max = maxVals[elements[i].name]
            
                                        if elements[i].textureof ~= nil and v.name == elements[i].textureof then
                                            TriggerEvent('skinchanger:change', elements[i].name, 0)
                                            newData.value = 0
                                        end
            
                                        --menu.update({name = elements[i].name}, newData)
                                    end
                                end)
                            end)
                        end

                        RageUI.Line()

                        RageUI.ButtonWithStyle("~g~Valider le Personnage", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                            
                                    SkinChanger.DeleteSkinCam()
                                end)

                                RageUI.CloseAll()
                            end
                        end)

                        RageUI.ButtonWithStyle("Retour", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SkinChanger.DeleteSkinCam()
                                SkinChanger.ReloadSkinPlayer()
                                RageUI.CloseAll()
                            end
                        end)
                    end)
    
                end
            end)
        end)
    end
end