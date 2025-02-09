-- Yvelt.#0001  |  For Back to Bronx 30/09/2023
fx_version "cerulean"
game "gta5"
lua54 "yes"

-------------------------------------------------------------------------------

server_scripts {
    '@oxmysql/lib/MySQL.lua',
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}

escrow_ignore {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    'config/esx-client.lua',
    'config/esx-server.lua',
    'config/onDeath.lua',
    'config/language.lua',
    'config/config.lua',
}

client_scripts {
    'config/esx-client.lua',
    'code/cl_zonegf.lua',
}

server_scripts {
    'config/esx-server.lua',
    'code/sv_zonegf.lua',
    'config/onDeath.lua',
}

shared_scripts {
    'config/language.lua',
    'config/config.lua',
}
dependency '/assetpacks'