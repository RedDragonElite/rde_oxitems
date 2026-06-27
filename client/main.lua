-- rde_oxitems | Client
-- Red Dragon Elite | SerpentsByte
-- v2.0.0

local State = {
    isOpen  = false,
    lang    = nil,    -- locale table received from server
}

-- ============================================
-- LOGGING
-- ============================================
local function Log(msg, level)
    if not Config.Debug and level ~= 'ERROR' then return end
    local prefix = level == 'ERROR' and '^1' or level == 'WARN' and '^3' or '^2'
    print(('%s[RDE OXITEMS]^7 %s'):format(prefix, msg))
end

-- ============================================
-- OPEN MANAGER COMMAND
-- ============================================
RegisterCommand('oxitems', function()
    -- Fetch language first, then items + properties in parallel via nested callbacks
    lib.callback('rde_oxitems:getLanguage', false, function(lang)
        if not lang then
            lib.notify({
                title       = Config.GetString('error'),
                description = Config.GetString('no_permission'),
                type        = 'error',
                icon        = 'shield-alert',
            })
            return
        end

        State.lang = lang

        lib.callback('rde_oxitems:getItems', false, function(items)
            if not items then return end

            lib.callback('rde_oxitems:getProperties', false, function(properties)
                SendNUIMessage({
                    type       = 'openManager',
                    items      = items,
                    properties = properties,
                    lang       = State.lang,
                })
                SetNuiFocus(true, true)
                State.isOpen = true
                Log('Manager opened', 'INFO')
            end)
        end)
    end)
end, false)

-- ============================================
-- STATEBAG — REAL-TIME SYNC
-- ============================================
AddStateBagChangeHandler(Config.StatebagPrefix .. 'update', nil, function(_, _, value)
    if not State.isOpen or not value then return end

    if value.action == 'reload' or value.action == 'create' or value.action == 'delete' then
        -- Re-fetch full item list on structural changes
        lib.callback('rde_oxitems:getItems', false, function(items)
            if not items then return end
            SendNUIMessage({ type = 'updateItems', items = items })
            lib.notify({
                title       = Config.GetString('success'),
                description = Config.GetString('items_synced'),
                type        = 'info',
                icon        = 'refresh-cw',
                duration    = 2000,
            })
        end)
    elseif value.action == 'update' and value.item then
        -- Lightweight update for single item edit
        SendNUIMessage({ type = 'updateSingleItem', item = value.item })
    end
end)

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    State.isOpen = false
    cb('ok')
end)

RegisterNUICallback('updateItem', function(data, cb)
    TriggerServerEvent('rde_oxitems:updateItem', data.item)
    cb('ok')
end)

RegisterNUICallback('createItem', function(data, cb)
    TriggerServerEvent('rde_oxitems:createItem', data.item)
    cb('ok')
end)

RegisterNUICallback('deleteItem', function(data, cb)
    TriggerServerEvent('rde_oxitems:deleteItem', data.name)
    cb('ok')
end)

RegisterNUICallback('reloadItems', function(_, cb)
    lib.callback('rde_oxitems:getItems', false, function(items)
        if items then
            SendNUIMessage({ type = 'updateItems', items = items })
            cb('ok')
        else
            cb('error')
        end
    end)
end)

RegisterNUICallback('importFromOx', function(_, cb)
    TriggerServerEvent('rde_oxitems:importFromOxInventory')
    cb('ok')
end)

-- ============================================
-- ESC KEY — Event-driven, not Wait(0) poll
-- ============================================
RegisterNetEvent('rde_oxitems:closeUI', function()
    if State.isOpen then
        SendNUIMessage({ type = 'close' })
        SetNuiFocus(false, false)
        State.isOpen = false
    end
end)

-- Use lib.keybind or key listener — but we need to catch ESC without Wait(0).
-- The NUI itself handles ESC via JS keydown; we also add a safety thread
-- with a 100ms poll — acceptable for a UI-only loop (not gameplay-critical).
CreateThread(function()
    while true do
        Wait(100)
        if State.isOpen and IsControlJustReleased(0, 322) then -- INPUT_FRONTEND_CANCEL = ESC
            SendNUIMessage({ type = 'close' })
            SetNuiFocus(false, false)
            State.isOpen = false
        end
    end
end)
