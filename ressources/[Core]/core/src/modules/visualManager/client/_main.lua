
HD_Cls.createClass("VisualManager", function(cls)
    local class = cls

    function class:DrawMarker(coords)
        DrawMarker(27, coords.x, coords.y, coords.z-0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    end

    function class:DrawText3D(coords, text)
        local onScreen,_x,_y=World3dToScreen2d(coords.x, coords.y, coords.z)
        SetTextScale(0.45, 0.45)
        SetTextFont(4)
        SetTextProportional(0)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end

    function class:KeyboardOutput(TextEntry, ExampleText, MaxStringLength)
        AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
        blockinput = true
        
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(1)
        end
        
        if UpdateOnscreenKeyboard() ~= 2 then
            local result = GetOnscreenKeyboardResult()
            Wait(500)
            blockinput = false
            return result
        else
            Wait(500)
            blockinput = false
            return nil
        end
    end

    function class:keyboardIsValid(result, isNumber)
        if result ~= nil then
            if isNumber then
                if tonumber(result) and tonumber(result) > 0 then
                    return tonumber(result)
                else
                    class:notify("~r~Invalide !")
                end
            else
                if tostring(result) and tostring(result) ~= '' then
                    return tostring(result)
                else
                    class:notify("~r~Invalide !")
                end
            end
        else
            class:notify("~r~Invalide !")
        end
    end

    function class:plyMarker(player)
        local ped = GetPlayerPed(player)
        local coords = GetEntityCoords(ped)
        local dist = Vdist(coords, pos)
        if dist < 2.5 then
            DrawMarker(22, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 203, 54, 148, 255, 0, 2, 1, nil, nil, 0)
        end
    end

    function class:notify(msg)
        Framework.ShowNotification(msg)
    end

    function class:helpNotify(msg)
        Framework.ShowHelpNotification(msg)
    end

    function class:loadingShow(loadingText, spinnerType)
        if IsLoadingPromptBeingDisplayed() then RemoveLoadingPrompt() end
        if (loadingText == nil) then
            BeginTextCommandBusyString(nil)
        else
            BeginTextCommandBusyString("STRING");
            AddTextComponentSubstringPlayerName(loadingText);
        end
        EndTextCommandBusyString(spinnerType)
    end

    function class:loadingHide() if IsLoadingPromptBeingDisplayed() then RemoveLoadingPrompt() end end

    function class:drawSprite(parent, component, x, y, width, height, heading, rgba)
        DrawSprite(parent, component, x, y, width, height, heading, rgba[1], rgba[2], rgba[3], rgba[4])
    end
    
   function class:drawSpriteWithSmooth(check, parent, component, x, y, width, height, heading, done)
        if not HasStreamedTextureDictLoaded(parent) then
            RequestStreamedTextureDict(parent, true)
            while not HasStreamedTextureDictLoaded(parent) do Wait(1) end
        end
    
        local smooth = 1
        
        CreateThread(function() while (smooth < 255) do smooth = (smooth+1) Wait(20) end end)

        CreateThread(function()
            while (check()) do DrawSprite(parent, component, x, y, width, height, heading, 255, 255, 255, smooth) Wait(1) end
            smooth = 255
    
            Wait(100)
            
            CreateThread(function() while (smooth > 1) do smooth = (smooth-1) Wait(20) end end)
            CreateThread(function()
                while (smooth > 1) do DrawSprite(parent, component, x, y, width, height, heading, 255, 255, 255, smooth) Wait(1) end
                if (done ~= nil) then done() end
            end)
        end)
    end

    function class:drawTextWithSmooth(check, x, y, text, color, done)
        local smooth = 1

        CreateThread(function() while (smooth < 255) do smooth = (smooth+1) Wait(20) end end)
        
        CreateThread(function()
            while (check()) do RenderText(text, x, y, 4, 2.0, color[1],color[2],color[3],smooth,"Center") Wait(1) end
            smooth = 255
    
            Wait(100)
    
            CreateThread(function() while (smooth > 1) do smooth = (smooth-1) Wait(20) end end)
            CreateThread(function()
                while (smooth > 1) do RenderText(text, x, y, 4, 2.0, color[1],color[2],color[3],smooth,"Center") Wait(1) end
                if (done ~= nil) then done() end
            end)
        end)
    end

    function class:drawSphere(coords, radius, r,g,b, opacity)
        DrawSphere(coords, radius, r, g, b, opacity)
    end

    return class
end)
