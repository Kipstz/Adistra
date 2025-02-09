shared_script '@ac/ai_module_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'
shared_scripts {
    'config.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
client_scripts {
    -- RageUI
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    
    'client/*.lua'
}
ui_page 'html/ui.html'
files {
    'html/ui.html',
    -- 'html/logo.png',
    'html/dmv.png',
    'html/cursor.png',
    'html/styles.css',
    'html/questions.js',
    'html/scripts.js',
    'html/debounce.min.js'
}