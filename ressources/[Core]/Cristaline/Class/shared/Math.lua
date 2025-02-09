__Math = {}

function __Math:percent(value, total)
    local percent = 100
    local percent = percent / total
    local percent = percent * value
    local percent = math.floor(percent)
    return percent
end

function __Math:FormatNumber(number)
    local formated = number
    if (formated == nil) then
        return 0
    end
    while true do
        formated, k = string.gsub(formated, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
        Wait(0)
    end
    return formated
end

function __Math:uuid()
    local uuid = ''
    for ii = 0, 31 do
        if ii == 8 or ii == 20 then
            uuid = uuid .. '-'
            uuid = uuid .. string.format('%x', math.floor(math.random() * 16))
        elseif ii == 12 then
            uuid = uuid .. '-'
            uuid = uuid .. '4'
        elseif ii == 16 then
            uuid = uuid .. '-'
            uuid = uuid .. string.format('%x', math.floor(math.random() * 4) + 8)
        else
            uuid = uuid .. string.format('%x', math.floor(math.random() * 16))
        end
    end
    return uuid
end