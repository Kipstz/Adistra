
Config['madrazo_vda'] = {
    jobs = {
        'madrazo'
    },

    localisations = {
        { pos = vector3(1402.1, 1134.4, 114.3), },
    },

    list = {
        cats = {
            { name = 'items', label = "Autres" },
        },

        weapons = {
            { cat = 'items', name = 'gpb', label = "Gilet-Par-Balle", price = 5000, action = function() Cayo_VDA:gpbEquip() end }
        }
    }
}