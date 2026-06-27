Config = {}

-- ============================================
-- CORE SETTINGS
-- ============================================
Config.Debug              = false
Config.DatabaseTable      = 'rde_items'
Config.StatebagPrefix     = 'rde_oxitems_'
Config.AllowAcePermissions = true
Config.AdminGroups        = { ['admin'] = true, ['superadmin'] = true, ['management'] = true, ['owner'] = true }

Config.Admin = {
    AcePermission = 'rde.oxitems.admin',
    SteamIDs = {
        -- 'steam:110000101605859',  -- Add SteamIDs here if needed
    },
}

-- ============================================
-- DEFAULT ITEM VALUES
-- ============================================
Config.DefaultValues = {
    weight    = 100,
    stack     = true,
    close     = true,
    consume   = 0,
    degrade   = false,
    allowArmed = false,
}

-- ============================================
-- ITEM PROPERTY DEFINITIONS
-- ============================================
Config.ItemProperties = {
    { name = 'name',          type = 'string',  required = true,  descriptionKey = 'prop_name' },
    { name = 'label',         type = 'string',  required = true,  descriptionKey = 'prop_label' },
    { name = 'weight',        type = 'number',  required = true,  descriptionKey = 'prop_weight' },
    { name = 'description',   type = 'string',  required = false, descriptionKey = 'prop_description' },
    { name = 'stack',         type = 'boolean', required = false, descriptionKey = 'prop_stack' },
    { name = 'close',         type = 'boolean', required = false, descriptionKey = 'prop_close' },
    { name = 'consume',       type = 'number',  required = false, descriptionKey = 'prop_consume' },
    { name = 'degrade',       type = 'number',  required = false, descriptionKey = 'prop_degrade' },
    { name = 'allowArmed',    type = 'boolean', required = false, descriptionKey = 'prop_allowArmed' },
    { name = 'weapon',        type = 'boolean', required = false, descriptionKey = 'prop_weapon' },
    { name = 'ammoname',      type = 'string',  required = false, descriptionKey = 'prop_ammoname' },
    { name = 'ammotype',      type = 'string',  required = false, descriptionKey = 'prop_ammotype' },
    { name = 'durability',    type = 'number',  required = false, descriptionKey = 'prop_durability' },
    { name = 'client_status', type = 'json',    required = false, descriptionKey = 'prop_client_status' },
    { name = 'client_anim',   type = 'json',    required = false, descriptionKey = 'prop_client_anim' },
    { name = 'client_prop',   type = 'json',    required = false, descriptionKey = 'prop_client_prop' },
    { name = 'client_usetime',type = 'number',  required = false, descriptionKey = 'prop_client_usetime' },
    { name = 'client_cancel', type = 'boolean', required = false, descriptionKey = 'prop_client_cancel' },
    { name = 'client_export', type = 'string',  required = false, descriptionKey = 'prop_client_export' },
    { name = 'client_event',  type = 'string',  required = false, descriptionKey = 'prop_client_event' },
    { name = 'server_export', type = 'string',  required = false, descriptionKey = 'prop_server_export' },
    { name = 'server_event',  type = 'string',  required = false, descriptionKey = 'prop_server_event' },
    { name = 'buttons',       type = 'json',    required = false, descriptionKey = 'prop_buttons' },
    { name = 'metadata',      type = 'json',    required = false, descriptionKey = 'prop_metadata' },
}

-- ============================================
-- LANGUAGE / LOCALES
-- ============================================
Config.DefaultLanguage = 'en'

Config.Locales = {
    en = {
        -- Notifications
        success            = 'Success',
        error              = 'Error',
        no_permission      = 'You do not have permission to use this tool',
        item_updated       = 'Item updated. Restart ox_inventory for permanent changes.',
        item_created       = 'Item added to session. Add it to ox_inventory/data/items.lua for permanence.',
        item_deleted       = 'Item removed from session. Delete it from ox_inventory/data/items.lua.',
        item_exists        = 'Item already exists or invalid name',
        item_not_found     = 'Item does not exist',
        import_done        = 'All items imported from ox_inventory!',
        reload_success     = 'Items reloaded successfully!',
        items_synced       = 'Item list synced in real-time!',

        -- NUI strings
        nui_title          = 'OX Inventory Manager — DB Edition',
        nui_import         = 'Import from OX',
        nui_close          = 'Close',
        nui_reload         = 'Reload',
        nui_search         = 'Search items...',
        nui_total_items    = 'Total Items',
        nui_page           = 'Page',
        nui_of             = 'of',
        nui_database       = 'Database',
        nui_weight_unit    = 'g',
        nui_edit_item      = 'Edit Item',
        nui_new_item       = 'Create New Item',
        nui_cancel         = 'Cancel',
        nui_save           = 'Save',
        nui_first          = 'First',
        nui_prev           = 'Back',
        nui_next           = 'Next',
        nui_last           = 'Last',
        nui_no_items       = 'No items found',
        nui_confirm_delete = 'Delete item "%s" from the database?',
        nui_confirm_import = 'Import all items from ox_inventory/data/items.lua into the database?',
        nui_badge_weapon   = 'Weapon',
        nui_badge_consume  = 'Consumable',
        nui_badge_degrade  = 'Degrades',

        -- Tabs
        tab_basic          = 'Basic',
        tab_behavior       = 'Behavior',
        tab_weapon         = 'Weapon',
        tab_client         = 'Client',
        tab_server         = 'Server',
        tab_advanced       = 'Advanced',

        -- Field labels
        field_name         = 'Item Name*',
        field_name_hint    = 'Lowercase, numbers and underscores only',
        field_label        = 'Display Name*',
        field_weight       = 'Weight (grams)*',
        field_description  = 'Description',
        field_stack        = 'Stackable',
        field_close        = 'Closes Inventory',
        field_allow_armed  = 'Allow while armed',
        field_consume      = 'Consume (0-1)',
        field_consume_hint = '0 = unlimited, 1 = single use',
        field_degrade      = 'Degrade time (minutes)',
        field_degrade_hint = 'Empty = no degradation',
        field_weapon       = 'Is a Weapon',
        field_ammoname     = 'Ammo Name',
        field_ammotype     = 'Ammo Type',
        field_durability   = 'Durability',
        field_usetime      = 'Use time (ms)',
        field_cancel       = 'Cancellable',
        field_export       = 'Client Export',
        field_event        = 'Client Event',
        field_status       = 'Status Effects (JSON)',
        field_anim         = 'Animation (JSON)',
        field_prop         = 'Prop (JSON)',
        field_server_export = 'Server Export',
        field_server_event  = 'Server Event',
        field_buttons      = 'Context Menu Buttons (JSON Array)',
        field_metadata     = 'Additional Metadata (JSON)',

        -- Validation
        val_name_label_required = 'Name and Label are required!',
        val_name_invalid        = 'Item name may only contain lowercase letters, numbers and underscores!',
        val_weight_negative     = 'Weight must be positive!',

        -- Property descriptions
        prop_name           = 'Technical name (lowercase, numbers, underscores)',
        prop_label          = 'Display name in inventory',
        prop_weight         = 'Weight in grams',
        prop_description    = 'Item description',
        prop_stack          = 'Can be stacked',
        prop_close          = 'Closes inventory on use',
        prop_consume        = 'Durability consumed per use (0-1)',
        prop_degrade        = 'Decay time in minutes (false = no decay)',
        prop_allowArmed     = 'Allows use while weapon is drawn',
        prop_weapon         = 'Is a weapon',
        prop_ammoname       = 'Ammo type for this weapon',
        prop_ammotype       = 'Ammo category (for ammo items)',
        prop_durability     = 'Maximum durability',
        prop_client_status  = 'Status effects (e.g. hunger, thirst)',
        prop_client_anim    = 'Animation on use (dict, clip)',
        prop_client_prop    = 'Prop on use (model, pos, rot)',
        prop_client_usetime = 'Use duration in milliseconds',
        prop_client_cancel  = 'Can be cancelled',
        prop_client_export  = 'Client export to call',
        prop_client_event   = 'Client event to trigger',
        prop_server_export  = 'Server export to call',
        prop_server_event   = 'Server event to trigger',
        prop_buttons        = 'Context menu buttons (JSON array)',
        prop_metadata       = 'Additional metadata (JSON)',
    },
    de = {
        -- Notifications
        success            = 'Erfolg',
        error              = 'Fehler',
        no_permission      = 'Du hast keine Berechtigung, dieses Tool zu nutzen',
        item_updated       = 'Item aktualisiert. Neustart von ox_inventory für permanente Änderungen.',
        item_created       = 'Item zur Session hinzugefügt. Füge es zu ox_inventory/data/items.lua hinzu.',
        item_deleted       = 'Item aus der Session entfernt. Lösche es aus ox_inventory/data/items.lua.',
        item_exists        = 'Item existiert bereits oder ungültiger Name',
        item_not_found     = 'Item existiert nicht',
        import_done        = 'Alle Items aus ox_inventory wurden importiert!',
        reload_success     = 'Items erfolgreich neu geladen!',
        items_synced       = 'Item-Liste wurde in Echtzeit synchronisiert!',

        -- NUI strings
        nui_title          = 'OX Inventory Manager — DB Edition',
        nui_import         = 'Von OX Importieren',
        nui_close          = 'Schließen',
        nui_reload         = 'Neu laden',
        nui_search         = 'Items durchsuchen...',
        nui_total_items    = 'Gesamt Items',
        nui_page           = 'Seite',
        nui_of             = 'von',
        nui_database       = 'Datenbank',
        nui_weight_unit    = 'g',
        nui_edit_item      = 'Item bearbeiten',
        nui_new_item       = 'Neues Item erstellen',
        nui_cancel         = 'Abbrechen',
        nui_save           = 'Speichern',
        nui_first          = 'Erste',
        nui_prev           = 'Zurück',
        nui_next           = 'Weiter',
        nui_last           = 'Letzte',
        nui_no_items       = 'Keine Items gefunden',
        nui_confirm_delete = 'Item "%s" wirklich aus der Datenbank löschen?',
        nui_confirm_import = 'Alle Items aus ox_inventory/data/items.lua in die Datenbank importieren?',
        nui_badge_weapon   = 'Waffe',
        nui_badge_consume  = 'Verbrauchbar',
        nui_badge_degrade  = 'Verfällt',

        -- Tabs
        tab_basic          = 'Basis',
        tab_behavior       = 'Verhalten',
        tab_weapon         = 'Waffe',
        tab_client         = 'Client',
        tab_server         = 'Server',
        tab_advanced       = 'Erweitert',

        -- Field labels
        field_name         = 'Item Name*',
        field_name_hint    = 'Nur Kleinbuchstaben, Zahlen und Unterstriche',
        field_label        = 'Anzeigename*',
        field_weight       = 'Gewicht (Gramm)*',
        field_description  = 'Beschreibung',
        field_stack        = 'Stapelbar',
        field_close        = 'Schließt Inventar',
        field_allow_armed  = 'Erlaubt mit Waffe',
        field_consume      = 'Verbrauch (0-1)',
        field_consume_hint = '0 = unbegrenzt, 1 = einmalig',
        field_degrade      = 'Verfallszeit (Minuten)',
        field_degrade_hint = 'Leer = kein Verfall',
        field_weapon       = 'Ist eine Waffe',
        field_ammoname     = 'Munitionsname',
        field_ammotype     = 'Munitionstyp',
        field_durability   = 'Haltbarkeit',
        field_usetime      = 'Nutzungsdauer (ms)',
        field_cancel       = 'Abbrechbar',
        field_export       = 'Client Export',
        field_event        = 'Client Event',
        field_status       = 'Status Effekte (JSON)',
        field_anim         = 'Animation (JSON)',
        field_prop         = 'Prop (JSON)',
        field_server_export = 'Server Export',
        field_server_event  = 'Server Event',
        field_buttons      = 'Context Menu Buttons (JSON Array)',
        field_metadata     = 'Zusätzliche Metadata (JSON)',

        -- Validation
        val_name_label_required = 'Name und Label sind erforderlich!',
        val_name_invalid        = 'Item Name darf nur Kleinbuchstaben, Zahlen und Unterstriche enthalten!',
        val_weight_negative     = 'Gewicht muss positiv sein!',

        -- Property descriptions
        prop_name           = 'Technischer Name (Kleinbuchstaben, Zahlen, Unterstriche)',
        prop_label          = 'Anzeigename im Inventar',
        prop_weight         = 'Gewicht in Gramm',
        prop_description    = 'Beschreibung des Items',
        prop_stack          = 'Kann gestapelt werden',
        prop_close          = 'Schließt Inventar beim Benutzen',
        prop_consume        = 'Durability-Verbrauch pro Nutzung (0-1)',
        prop_degrade        = 'Verfallszeit in Minuten (false = kein Verfall)',
        prop_allowArmed     = 'Erlaubt Nutzung während Waffe gezogen ist',
        prop_weapon         = 'Ist eine Waffe',
        prop_ammoname       = 'Munitionstyp für diese Waffe',
        prop_ammotype       = 'Munitionskategorie (für Munitionsitems)',
        prop_durability     = 'Maximale Haltbarkeit',
        prop_client_status  = 'Status-Effekte (z.B. hunger, thirst)',
        prop_client_anim    = 'Animation beim Benutzen (dict, clip)',
        prop_client_prop    = 'Prop beim Benutzen (model, pos, rot)',
        prop_client_usetime = 'Nutzungsdauer in Millisekunden',
        prop_client_cancel  = 'Kann Nutzung abgebrochen werden',
        prop_client_export  = 'Client Export der ausgeführt wird',
        prop_client_event   = 'Client Event der ausgelöst wird',
        prop_server_export  = 'Server Export der ausgeführt wird',
        prop_server_event   = 'Server Event der ausgelöst wird',
        prop_buttons        = 'Context Menu Buttons (JSON Array)',
        prop_metadata       = 'Zusätzliche Metadata (JSON)',
    },
}

function Config.GetString(key, ...)
    local lang = Config.Locales[Config.DefaultLanguage] or Config.Locales['en']
    local str  = lang[key] or (Config.Locales['en'] and Config.Locales['en'][key]) or key
    if select('#', ...) > 0 then return string.format(str, ...) end
    return str
end


