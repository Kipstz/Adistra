CreateThread(function()
    while true do
        Wait(30000)

        local propspostable = {}
        local props = GetAllObjects()

        for _, prop in pairs(props) do
            local propcord = GetEntityCoords(prop)

            if propspostable[propcord] == nil then
                propspostable[propcord] = true
            else
                DeleteEntity(prop)
            end
            
            if GetEntityModel(prop) == 0 then
                DeleteEntity(prop)
            end
        end
    end
end)