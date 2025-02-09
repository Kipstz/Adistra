
function MenuDev:isWlAccess(src)
    local canAccess = nil;
    Framework.TriggerServerCallback('menudev:isWlAccess', function(can)
        if can then canAccess = true; else canAccess = false; end
    end)
    while canAccess == nil do Wait(100) end
    return canAccess;
end