function CartelCayo_VDA:isJob()
    for k,v in pairs(Config['cartelcayo_vda'].jobs) do
        print(v)
        print(Framework.PlayerData.jobs['job2'].grade)
        if Framework.PlayerData.jobs['job2'].name == v and Framework.PlayerData.jobs['job2'].grade >= 17 then
            return true;
        end
    end
    return false;
end