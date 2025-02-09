shared_script '@ac/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'
author 'Nyaku'
this_is_a_map 'yes'

escrow_ignore {
    'Modules/shared/*.lua',
}

shared_scripts {"Class/shared/*.lua","Modules/**/shared/*.lua"}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "Class/server/*.lua",
    "Modules/**/server/*.lua"
}


client_scripts {
    "Dependencies/RageUI/RMenu.lua",
    "Dependencies/RageUI//menu/RageUI.lua",
    "Dependencies/RageUI//menu/Menu.lua",
    "Dependencies/RageUI//menu/MenuController.lua",
    "Dependencies/RageUI//components/*.lua",
    "Dependencies/RageUI//menu/elements/*.lua",
    "Dependencies/RageUI//menu/items/*.lua",
    "Dependencies/RageUI//menu/panels/*.lua",
    "Dependencies/RageUI//menu/windows/*.lua",
    "Class/client/*.lua",
    "Modules/**/client/*.lua"
}