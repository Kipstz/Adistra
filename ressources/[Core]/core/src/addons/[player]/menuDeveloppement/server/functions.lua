
function MenuDev:canAccess(src)
    local xPlayer = Framework.GetPlayerFromId(src)
    local canAccess = false;
    for k,v in pairs(Config['menu_dev'].wlLicenses) do
        if xPlayer.identifier == v then canAccess = true; end
    end
    return canAccess;
end