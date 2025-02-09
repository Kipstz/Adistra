Config['banques'] = {
    MenuTitle = {
        MainMenu = "Banques",
    },
    MenuSubTitle = {
        MainMenu = "Actions:",
        CategoryMenu = "Actions:"
    },

    localisations = {}
}

if Config:gabz() then
    Config['banques'].localisations = {
        { pos = vector3(150.266, -1040.203, 29.374) },
        { pos = vector3(-1212.980, -330.841, 37.787) },
        { pos = vector3(-2962.582, 482.627, 15.703) },
        { pos = vector3(-112.202, 6469.295, 31.626) },
        { pos = vector3(314.187, -278.621, 54.170) },
        { pos = vector3(-351.534, -49.529, 49.042) },
        { pos = vector3(252.33, 218.11, 106.29) },
        { pos = vector3(1175.064, 2706.643, 38.094) },
        { pos = vector3(4492.735, -4521.166, 4.412) } -- Cayo
    }
else
    Config['banques'].localisations = {
        { pos = vector3(150.266, -1040.203, 29.374) },
        { pos = vector3(-1212.980, -330.841, 37.787) },
        { pos = vector3(-2962.582, 482.627, 15.703) },
        { pos = vector3(-112.202, 6469.295, 31.626) },
        { pos = vector3(314.187, -278.621, 54.170) },
        { pos = vector3(-351.534, -49.529, 49.042) },
        { pos = vector3(247.3, 222.2, 106.3) },
        { pos = vector3(1175.064, 2706.643, 38.094) },
        { pos = vector3(4492.735, -4521.166, 4.412) } -- Cayo
    }
end