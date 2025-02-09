HD_Cls.createClass("Web", function(cls)
    ---@class Web : CLS.Object
    local class = cls;

    function class:constructor() end

    function class:open(type)
        SendNUIMessage({
            open = tostring(type),
        })
        
        SetNuiFocus(true, true)
        DisplayRadar(false)
    end

    function class:netEvent(eventName, ...)
        RegisterNUICallback(eventName, ...);
    end

    function class:triggerEvent(data)
        SendNUIMessage(data)
    end

    RegisterNUICallback('close', function(value, cb)
        SetNuiFocus(false, false)
        DisplayRadar(true)
        TriggerScreenblurFadeOut(0.5)
    end)

    return class;
end)