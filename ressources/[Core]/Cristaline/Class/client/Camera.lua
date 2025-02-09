__Camera = {}
__Camera.cache = {}

---@class Camera : __Camera
---@param name string
---@param pos table
---@param heading number
---@param fieldOfView number
function __Camera:create(name, pos, heading, fieldOfView)
    if not __Camera.cache[name] then
        __Camera.cache[name] = {}
    end
    __Camera.cache[name] = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y + 0.5, pos.z + 0.5, 0.0, 0.0, heading, 60.00, false, 0)
    SetCamActive(__Camera.cache[name], true)
    SetCamFov(__Camera.cache[name], fieldOfView)
    return __Camera.cache[name]
end

---@param name string
---@param render boolean
function __Camera:render(name, render)
    if __Camera.cache[name] then
        RenderScriptCams(render, false, 1, true, true)
    end
end

---@param name string
function __Camera:delete(name)
    if __Camera.cache[name] then
        DestroyCam(__Camera.cache[name], false)
        RenderScriptCams(false, false, 1, true, true)
        __Camera.cache[name] = nil
    end
end

---@param name string
---@param fieldOfView number
function __Camera:setFOV(name, fieldOfView)
    if __Camera.cache[name] then
        SetCamFov(__Camera.cache[name], fieldOfView)
    end
end

function __Camera:debug()
    RenderScriptCams(false, false, 1, true, true)
end