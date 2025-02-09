shared_script '@ac/ai_module_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'
description "Base Serveur"
author "Adistra"
version '0.2'
lua54 'yes'
ui_page "src/web/ui/index.html"
files {
    -- UIX --
    "src/web/ui/index.html",
    "src/web/ui/init.js",
    "src/web/ui/init.css",
    "src/web/ui/source/**/*.js",
    "src/web/ui/source/**/*.css",
    "src/web/ui/images/**/*.png",
    --"src/web/ui/images/**/*.svg",
    -- LOADING --
    'src/web/loading/css/*.css',
    'src/web/loading/js/*.js',
    'src/web/loading/img/*.png',
    'src/web/loading/music/*.mp3',
    'src/web/loading/index.html',
}
client_scripts {
    -- RageUI
    'src/vendors/RageUI/RMenu.lua',
    'src/vendors/RageUI/menu/RageUI.lua',
    'src/vendors/RageUI/menu/Menu.lua',
    'src/vendors/RageUI/menu/MenuController.lua',
    'src/vendors/RageUI/components/*.lua',
    'src/vendors/RageUI/menu/elements/*.lua',
    'src/vendors/RageUI/menu/items/*.lua',
    'src/vendors/RageUI/menu/panels/*.lua',
    'src/vendors/RageUI/menu/windows/*.lua',
}
shared_scripts {
    -- Config
    'config/global.lua',
    'config/**/*.lua',
    -- MODULES
    'src/modules/classConstructor.lua',
    'src/modules/**/shared/*.lua',
}
client_scripts {
    --INIT
    'src/_init/client/*.lua',
    -- MODULES
    'src/modules/**/client/*.lua',
    --COMPONENTS
    'src/components/**/client/**/*.lua',
    
    --Addons
    'src/addons/**/client/**/*.lua',
    
    -- Jobs
    'src/jobs/**/client/*.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- INIT
    'src/_init/server/*.lua',
    -- MODULES
    -- 'src/modules/**/server/*.lua',
    --COMPONENTS
    'src/components/**/server/**/*.lua',
    --Addons
    'src/addons/**/server/*.lua',
    -- Jobs
    'src/jobs/**/server/*.lua',
}
exports {
	'GeneratePlate',
	'GenerateSocietyPlate',
    'GetStatus'
}
