
function Vip:getVip()
    local vipReturn = nil;
    Framework.TriggerServerCallback("vip:getVip", function(vip)
        if vip then
            vipReturn = vip;
        else
            vipReturn = false;
        end
    end)
    Wait(250)
    return vipReturn;
end

function Vip:isBlackListModel(model)
    for k,v in pairs(Config['vip'].pedBlacklist) do 
        if v == model then
            return true;
        end
    end
    return false;
end

function Vip:wlLevel(vip, item)
    for k,v in pairs(Config['vip'].levels[vip.level].access) do
        if v == item then
            return true;
        end
    end
    return false;
end