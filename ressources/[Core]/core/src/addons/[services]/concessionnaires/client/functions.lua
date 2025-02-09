
function Concess:ActiveCam(coords, rotX, fov)
    DestroyAllCams(true)
    camStart = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, -10.0, 0.0, rotX, fov)
    SetCamActive(camStart, true)
    RenderScriptCams(true, false, 0, true, false)
end

function Concess:DestroyCam()
    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, true, false)
end