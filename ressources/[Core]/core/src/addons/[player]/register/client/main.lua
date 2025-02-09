
RegisterNetEvent("core:openMenuRegister")
AddEventHandler("core:openMenuRegister", function()
    SkinChanger.OpenMenu()
end)


RegisterCommand("registerSpawn", function(source, args, rawCommand)
    TriggerServerEvent("core:registerSpawn")
end)