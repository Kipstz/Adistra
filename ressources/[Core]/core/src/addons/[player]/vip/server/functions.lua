function Vip:getVip(src)
    local src = src
    local xPlayer = Framework.GetPlayerFromId(src)

    local vip = MySQL.query.await('SELECT * FROM `vips` WHERE `owner` = ?', {xPlayer.identifier})

    if vip and vip[1] then
        local dateEndNum = tonumber(vip[1].dateEnd)
        if not dateEndNum then
            Vip:removeVip(src)
            xPlayer.showNotification("~r~Date de fin VIP invalide~s~")
            return
        end

        local timestampSeconds = math.floor(dateEndNum / 1000)
        
        local success, dateEnd = pcall(os.date, "*t", timestampSeconds)
        if not success then
            Vip:removeVip(src)
            xPlayer.showNotification("~r~Erreur de date VIP~s~")
            return
        end

        local currentDate = os.date("*t")
        
        if (dateEnd.year < currentDate.year) or 
           (dateEnd.year == currentDate.year and dateEnd.month < currentDate.month) then
            Vip:removeVip(src)
            xPlayer.showNotification("~r~Votre VIP a expiré !~s~")
            return
        end

        local vipInfos = {
            level = vip[1].level,
            dateSuscribe = Vip:transformDateLabel(vip[1].dateSuscribe),
            dateEnd = Vip:transformDateLabel(dateEndNum),
            dateMoney = Vip:getDateGainLabel(vip[1].dateMoney),
            dateCoins = Vip:getDateGainLabel(vip[1].dateCoins),
        }
        return vipInfos
    else
        return false
    end
end

function Vip:isNaN(value)
    return value ~= value
end

function Vip:isVip(src)
    local src = src;
    local xPlayer = Framework.GetPlayerFromId(src)
    local vip = MySQL.query.await('SELECT * FROM `vips` WHERE `owner` = ?', {xPlayer.identifier})
    if vip ~= nil and vip[1] ~= nil then return true end
    return false
end

function Vip:updateDateMoneyBonus(identifier)
    MySQL.update.await('UPDATE vips SET dateMoney = ? WHERE owner = ?', {
        os.date("%Y-%m-%d"), identifier
    })
end

function Vip:updateDateCoinsBonus(identifier)
    MySQL.update.await('UPDATE vips SET dateCoins = ? WHERE owner = ?', {
        os.date("%Y-%m-%d"), identifier
    })
end

function Vip:addVip(src, level, lifetime)
    local xPlayer = Framework.GetPlayerFromId(src)
    local vip = MySQL.scalar.await('SELECT * FROM `vips` WHERE `owner` = ?', {xPlayer.identifier})

    if vip == nil then
        if not lifetime then
            local vip = MySQL.insert.await("INSERT INTO `vips` (owner, level, dateSuscribe, dateEnd) VALUES (?, ?, ?, ?)", {
                xPlayer.identifier, level, os.date("%Y-%m-%d"), Vip:calculDateEnd(month)
            })
        else
            local vip = MySQL.insert.await("INSERT INTO `vips` (owner, level, dateSuscribe, dateEnd) VALUES (?, ?, ?, ?)", {
                xPlayer.identifier, level, os.date("%Y-%m-%d"), nil
            })
        end
    else
        print("^1Impossible d'ajouter le VIP à l'ID ^2"..src.."^1: Le joueur est déjà VIP !^0")
    end
end

function Vip:removeVip(src)
    local xPlayer = Framework.GetPlayerFromId(src)
    MySQL.query.await('DELETE FROM `vips` WHERE `owner` = ?', { xPlayer.identifier })    
end

function Vip:calculDateEnd(month)
    local date = os.date("%Y-%m-%d")
    local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
    local dateTable = { year = tonumber(year), month = tonumber(month), day = tonumber(day) }

    dateTable.month = dateTable.month + month

    if dateTable.month > 12 then
        dateTable.month = month;
        dateTable.year = dateTable.year + 1;
    end

    local lastDayOfMonth = os.date("%d", os.time({year = dateTable.year, month = dateTable.month + 1, day = 0}))
    dateTable.day = math.min(dateTable.day, tonumber(lastDayOfMonth))

    local newDate = os.date("%Y-%m-%d", os.time(dateTable))
    return newDate
end

function Vip:transformDateLabel(date)
    if tostring(date) ~= 'nan' and tostring(date/1000) ~= 'nan' then
        return os.date("%d-%m-%Y", (date/1000))
    else
        return "LIFETIME";
    end
end

function Vip:getDateGainLabel(date)
    if tostring(date) ~= 'nan' and tostring(date/1000) ~= 'nan' then
        return os.date("%d-%m-%Y", (date/1000))
    else
        return nil
    end
end

function Vip:wlLevel(vip, item)
    for k,v in pairs(Config['vip'].levels[vip.level].access) do
        if v == item then
            return true;
        end
    end
    return false;
end