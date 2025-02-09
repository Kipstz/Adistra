__Visual = {}

function __Visual:drawMarker(coords)
    DrawMarker(6, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 1, nil, nil, 0)
end

function __Visual:keyboardInput()
    Citizen.CreateThread(function()
        local input = ""
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
        while UpdateOnscreenKeyboard() == 0 do
            DisableAllControlActions(0)
            Wait(0)
        end
        if GetOnscreenKeyboardResult() then
            input = GetOnscreenKeyboardResult()
        end
        return input
    end)
end

function __Visual:drawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

function __Visual:drawTextOnScreen(x, y, text)
    SetTextFont(0)
    SetTextScale(0.0, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end