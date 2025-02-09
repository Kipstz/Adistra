

CreateThread(function()
    for k,v in pairs(Config['utils'].Blips) do
        BlipManager:addBlip('blip_'..k, v.pos, v.sprite, v.color, v.name, v.scale, true)

        if v.ZoneBlip then
            local zoneblip = AddBlipForRadius(v.pos, 800.0)
            
            SetBlipSprite(zoneblip,1)
            SetBlipColour(zoneblip, v.color)
            SetBlipAlpha(zoneblip,100)
        end
    end
end)
