
AdminMenu.isStaff = function(src)
    for k,v in pairs(Config['AdminMenu'].groupsWL) do
        if AdminMenu.players[src].group == v then
            return true
        end
    end

    return false
end