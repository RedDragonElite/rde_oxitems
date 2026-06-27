-- rde_oxitems | Server
-- Red Dragon Elite | SerpentsByte
-- v2.0.0

-- ============================================
-- LOGGING
-- ============================================
local function Log(msg, level)
    if not Config.Debug and level ~= 'ERROR' then return end
    local prefix = level == 'ERROR' and '^1' or level == 'WARN' and '^3' or '^2'
    print(('%s[RDE OXITEMS]^7 %s'):format(prefix, msg))
end

-- ============================================
-- ADMIN CHECK (Triple-Layer: ACE → ox_core → SteamID)
-- ============================================
local function IsAdmin(source)
    if not source or source == 0 then return true end

    -- 1️⃣ ACE Permission
    if Config.AllowAcePermissions then
        if IsPlayerAceAllowed(source, Config.Admin.AcePermission) then return true end
        if IsPlayerAceAllowed(source, 'command')                  then return true end
        if IsPlayerAceAllowed(source, 'admin')                    then return true end
    end

    -- 2️⃣ ox_core Groups
    local player = Ox.GetPlayer(source)
    if player and player.getGroups then
        for groupName in pairs(player.getGroups()) do
            if Config.AdminGroups[groupName] then return true end
        end
    end

    -- 3️⃣ SteamID fallback
    if Config.Admin.SteamIDs and #Config.Admin.SteamIDs > 0 then
        local identifiers = GetPlayerIdentifiers(source)
        for _, steamID in ipairs(Config.Admin.SteamIDs) do
            for _, id in ipairs(identifiers) do
                if id:lower() == steamID:lower() then return true end
            end
        end
    end

    Log(('SECURITY: Unauthorized access attempt by source %d'):format(source), 'WARN')
    return false
end
exports('isAdmin', IsAdmin)

-- ============================================
-- NOTIFICATION DEDUP (anti-spam)
-- ============================================
local NotifCache = {}

local function Notify(source, title, desc, ntype, duration)
    if not source or source == 0 then return end
    local hash = ('%d:%s:%s'):format(source, title, desc)
    local now  = GetGameTimer()
    if NotifCache[hash] and (now - NotifCache[hash] < 2000) then return end
    NotifCache[hash] = now
    TriggerClientEvent('ox_lib:notify', source, {
        title       = title,
        description = desc,
        type        = ntype or 'info',
        duration    = duration or 5000,
    })
end

-- ============================================
-- DATABASE SETUP
-- ============================================
local function SetupDatabase()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `rde_items` (
            `name`       VARCHAR(50)   NOT NULL,
            `data`       LONGTEXT      NOT NULL,
            `updated_at` TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ]], {}, function()
        Log('Database table `rde_items` ready.', 'INFO')
    end)
end

-- ============================================
-- CALLBACKS
-- ============================================
lib.callback.register('rde_oxitems:getItems', function(source)
    if not IsAdmin(source) then return false end
    return exports.ox_inventory:Items()
end)

lib.callback.register('rde_oxitems:getProperties', function(source)
    if not IsAdmin(source) then return false end
    return Config.ItemProperties
end)

lib.callback.register('rde_oxitems:getLanguage', function(source)
    if not IsAdmin(source) then return false end
    -- Return the full locale table for the configured default language
    local lang = Config.Locales[Config.DefaultLanguage] or Config.Locales['en']
    return lang
end)

-- ============================================
-- NET EVENTS — CREATE / UPDATE / DELETE / IMPORT
-- ============================================

-- ✨ Create Item
RegisterNetEvent('rde_oxitems:createItem', function(itemData)
    local source = source
    if not IsAdmin(source) then
        DropPlayer(source, 'Unauthorized access attempt (createItem)')
        return
    end

    local items = exports.ox_inventory:Items()
    if not items then
        Notify(source, Config.GetString('error'), 'ox_inventory not available', 'error')
        return
    end

    if items[itemData.name] then
        Notify(source, Config.GetString('error'), Config.GetString('item_exists'), 'error')
        return
    end

    local newItem = {
        name        = itemData.name,
        label       = itemData.label or itemData.name,
        weight      = tonumber(itemData.weight) or 0,
        stack       = itemData.stack ~= nil and itemData.stack or true,
        close       = itemData.close ~= nil and itemData.close or true,
        description = itemData.description or '',
        client      = itemData.client or nil,
        server      = itemData.server or nil,
        buttons     = itemData.buttons or nil,
        consume     = itemData.consume or nil,
        durability  = itemData.durability or nil,
        degrade     = itemData.degrade or nil,
        ammoname    = itemData.ammoname or nil,
        ammotype    = itemData.ammotype or nil,
        weapon      = itemData.weapon or nil,
    }

    exports.ox_inventory:Items(newItem.name, newItem)

    MySQL.insert(
        'INSERT INTO rde_items (name, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?',
        { newItem.name, json.encode(newItem), json.encode(newItem) }
    )

    GlobalState[Config.StatebagPrefix .. 'update'] = { action = 'create', item = newItem, ts = GetGameTimer() }

    Notify(source, Config.GetString('success'), Config.GetString('item_created'), 'success', 7000)
    Log(('Item created: %s'):format(newItem.name), 'INFO')
end)

-- 📝 Update Item
RegisterNetEvent('rde_oxitems:updateItem', function(itemData)
    local source = source
    if not IsAdmin(source) then
        DropPlayer(source, 'Unauthorized access attempt (updateItem)')
        return
    end

    local items = exports.ox_inventory:Items()
    if not items or not items[itemData.name] then
        Notify(source, Config.GetString('error'), Config.GetString('item_not_found'), 'error')
        return
    end

    local existing = items[itemData.name]
    local updatedItem = {
        name        = itemData.name,
        label       = itemData.label       or existing.label,
        weight      = tonumber(itemData.weight) or existing.weight or 0,
        stack       = itemData.stack ~= nil and itemData.stack or existing.stack,
        close       = itemData.close ~= nil and itemData.close or existing.close,
        description = itemData.description or existing.description or '',
        client      = itemData.client      or existing.client,
        server      = itemData.server      or existing.server,
        buttons     = itemData.buttons     or existing.buttons,
        consume     = itemData.consume     or existing.consume,
        durability  = itemData.durability  or existing.durability,
        degrade     = itemData.degrade     or existing.degrade,
        ammoname    = itemData.ammoname    or existing.ammoname,
        ammotype    = itemData.ammotype    or existing.ammotype,
        weapon      = itemData.weapon      or existing.weapon,
    }

    exports.ox_inventory:Items(updatedItem.name, updatedItem)

    MySQL.update(
        'UPDATE rde_items SET data = ? WHERE name = ?',
        { json.encode(updatedItem), updatedItem.name }
    )

    GlobalState[Config.StatebagPrefix .. 'update'] = { action = 'update', item = updatedItem, ts = GetGameTimer() }

    Notify(source, Config.GetString('success'), Config.GetString('item_updated'), 'success', 5000)
    Log(('Item updated: %s'):format(updatedItem.name), 'INFO')
end)

-- ❌ Delete Item
RegisterNetEvent('rde_oxitems:deleteItem', function(itemName)
    local source = source
    if not IsAdmin(source) then
        DropPlayer(source, 'Unauthorized access attempt (deleteItem)')
        return
    end

    local items = exports.ox_inventory:Items()
    if not items or not items[itemName] then
        Notify(source, Config.GetString('error'), Config.GetString('item_not_found'), 'error')
        return
    end

    exports.ox_inventory:Items(itemName, false)

    MySQL.query('DELETE FROM rde_items WHERE name = ?', { itemName })

    GlobalState[Config.StatebagPrefix .. 'update'] = { action = 'delete', name = itemName, ts = GetGameTimer() }

    Notify(source, Config.GetString('success'), Config.GetString('item_deleted'), 'warning', 7000)
    Log(('Item deleted: %s'):format(itemName), 'INFO')
end)

-- ☁️ Import from ox_inventory
RegisterNetEvent('rde_oxitems:importFromOxInventory', function()
    local source = source
    if not IsAdmin(source) then
        DropPlayer(source, 'Unauthorized access attempt (importFromOxInventory)')
        return
    end

    local items = exports.ox_inventory:Items()
    if not items then
        Notify(source, Config.GetString('error'), 'ox_inventory not available', 'error')
        return
    end

    local batch = {}
    for name, item in pairs(items) do
        batch[#batch + 1] = { name, json.encode(item), json.encode(item) }
    end

    -- Batch insert to avoid hammering the DB
    for _, row in ipairs(batch) do
        MySQL.insert(
            'INSERT INTO rde_items (name, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?',
            row
        )
    end

    GlobalState[Config.StatebagPrefix .. 'update'] = { action = 'reload', ts = GetGameTimer() }

    Notify(source, Config.GetString('success'), Config.GetString('import_done'), 'success', 5000)
    Log(('Import from ox_inventory completed — %d items'):format(#batch), 'INFO')
end)

-- ============================================
-- AUTO-SAVE THREAD (every 5 minutes)
-- ============================================
CreateThread(function()
    -- Wait for DB to be available before first save
    Wait(30000)

    SetupDatabase()

    while true do
        Wait(300000) -- 5 minutes

        local items = exports.ox_inventory:Items()
        if items then
            for name, item in pairs(items) do
                MySQL.insert(
                    'INSERT INTO rde_items (name, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?',
                    { name, json.encode(item), json.encode(item) }
                )
            end
            Log('Auto-save completed.', 'INFO')
        end
    end
end)

-- ============================================
-- CLEANUP THREAD (every 10 minutes)
-- ============================================
CreateThread(function()
    while true do
        Wait(600000)
        local now = GetGameTimer()
        for k, ts in pairs(NotifCache) do
            if ts < now - 600000 then NotifCache[k] = nil end
        end
    end
end)

-- ============================================
-- STARTUP / SHUTDOWN
-- ============================================
AddEventHandler('onResourceStart', function(name)
    if name ~= GetCurrentResourceName() then return end
    CreateThread(function()
        local attempts = 0
        while not Ox and attempts < 100 do
            Wait(100)
            attempts = attempts + 1
        end
        if not Ox then
            Log('ox_core not found! Aborting startup.', 'ERROR')
            return
        end
        SetupDatabase()
        Log('Resource started.', 'INFO')
    end)
end)

AddEventHandler('onResourceStop', function(name)
    if name ~= GetCurrentResourceName() then return end
    -- Clean up statebags
    GlobalState[Config.StatebagPrefix .. 'update'] = nil
    Log('Resource stopped.', 'INFO')
end)
