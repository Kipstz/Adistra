__Nui = {}

--- Open a NUI component
---@param component string
---@param data table
---@return void
---@public
---@example
--- __Nui:Open('inventory', {
---     items = {
---         { name = 'bread', label = 'Bread', count = 1 },
---         { name = 'water', label = 'Water', count = 1 }
---     }
--- }, true, true)
function __Nui:open(component, data, focus, keyboard)
    SendNUIMessage({
        action = 'toggle',
        data = {
            component = component,
            bool = true,
            data = data or {}
        }
    })
end

--- Close a NUI component
---@param component string
---@return void
function __Nui:close(component)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        action = 'toggle',
        data = {
            component = component,
            bool = false,
            data = {}
        }
    })
end

--- Send a message to a NUI component
---@param component string
---@param data table
---@return void
function __Nui:send(component, title, data)
    SendNUIMessage({
        action = component..":"..title,
        data = data or {}
    })
end

-- Control NUI focus
---@param focus boolean
---@param keyboard boolean
---@return void
function __Nui:focus(focus, keyboard)
    SetNuiFocus(focus, focus)
    SetNuiFocusKeepInput(keyboard)
end

--- Register a NUI event
---@param event string
---@param callback function
---@return void
function __Nui:registerEvent(event, callback)
    RegisterNuiCallbackType(event)
    AddEventHandler('Nevada__Nui:' .. event, function(data, cb)
        callback(data, cb)
    end)
end

RegisterNUICallback("Nevada:web:hideframe", function(data, cb)
    for k,v in pairs(data) do
        if not v.name == "menu" then
            __Nui:close(v.name)
        end
    end
end)