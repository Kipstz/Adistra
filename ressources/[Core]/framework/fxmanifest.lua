shared_script '@ac/ai_module_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'
description "Framework"
author "Adistra"
version '0.1'
lua54 'yes'
ui_page {
	'html/ui.html'
}
files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
}
client_scripts {
    -- RageUI
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
}
shared_scripts {
    "locales/locale.lua",
    "locales/fr.lua",
    "shared/**/*.lua",
}
client_scripts {
    "client/**/*.lua",
    "common/modules/math.lua",
	"common/modules/table.lua",
	"common/functions.lua",
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/init/_init.lua",
    "server/classes/*.lua",
    "server/*.lua",
    
    "common/modules/math.lua",
	"common/modules/table.lua",
	"common/functions.lua",
}

exports {
	'ReloadItems',
	'ReloadJobs'
}server_scripts { '@mysql-async/lib/MySQL.lua' }