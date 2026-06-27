fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'rde_oxitems'
author      'Red Dragon Elite | SerpentsByte'
description 'Advanced OX Inventory Item Manager - DB Edition'
version     '2.0.0'

dependencies {
    '/server:7290',
    'oxmysql',
    'ox_lib',
    'ox_core',
    'ox_inventory',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@ox_core/lib/init.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/rdwe-ui.css',
    'web/rdwe-ui.js',
}
