# 🐉 rde_oxitems

🔥 ADVANCED OX INVENTORY ITEM MANAGER V2.0.0 — DB Edition — Runtime Injection, Lua Export Generator, Realtime NUI, RDWE-UI, Full ox_inventory Compatibility! 🐉

[![Version](https://img.shields.io/badge/version-2.0.0-red?style=for-the-badge)](https://github.com/RedDragonElite/rde_oxitems)
[![License](https://img.shields.io/badge/license-RDE%20Black%20Flag%20v6.66-black?style=for-the-badge)](https://github.com/RedDragonElite/rde_oxitems/blob/main/LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue?style=for-the-badge)](https://fivem.net)
[![ox_inventory](https://img.shields.io/badge/Inventory-ox__inventory-blue?style=for-the-badge)](https://github.com/overextended/ox_inventory)
[![ox_core](https://img.shields.io/badge/Framework-ox__core-blue?style=for-the-badge)](https://github.com/overextended/ox_core)
[![Price](https://img.shields.io/badge/price-FREE%20FOREVER-brightgreen?style=for-the-badge)](https://github.com/RedDragonElite/rde_oxitems)
[![RDE Ecosystem](https://img.shields.io/badge/RDE-ECOSYSTEM-f59e0b?style=for-the-badge)](https://github.com/RedDragonElite)

**Create, edit, and delete ox_inventory items at runtime — without touching a single Lua file. All items persist in a dedicated MySQL table and are injected back into ox_inventory on every server start. Export a ready-to-paste Lua block for permanent items.lua integration. Fully admin-gated, statebag-synced, and built on the RDWE-UI framework.**

> Built on ox_core · ox_lib · ox_inventory · oxmysql
>
> Built by Red Dragon Elite | SerpentsByte

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Why rde_oxitems?](#-why-rde_oxitems)
- [Features](#-features)
- [How Runtime Injection Works](#-how-runtime-injection-works)
- [Lua Export Generator](#-lua-export-generator)
- [Dependencies](#-dependencies)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Architecture](#-architecture)
- [Security](#-security)
- [Commands](#-commands)
- [Database](#-database)
- [Performance](#-performance)
- [Troubleshooting](#-troubleshooting)
- [Changelog](#-changelog)
- [License](#-license)

---

## 🎯 Overview

rde_oxitems is a database-driven item manager for ox_inventory. It replaces the workflow of editing `items.lua` by hand with a fully in-game NUI panel where admins can create, edit, and delete items at runtime — and have those items persist across restarts without modifying any ox_inventory file.

Every item is stored in the `rde_items` MySQL table. On every server start, rde_oxitems reads that table and injects all items into ox_inventory's runtime cache via the `exports.ox_inventory:Items()` setter. From ox_inventory's perspective, there is no difference between items loaded from `items.lua` and items injected by rde_oxitems — they behave identically.

When you're ready to make an item permanent and survive a full server wipe, the built-in **Lua Export Generator** outputs a ready-to-paste Lua block with full syntax highlighting — paste it into `items.lua` or your own `rde_items_data.lua` file registered via `data_file` in ox_inventory's fxmanifest.

**The panel itself is built entirely in RDWE-UI** — the Red Dragon Web Engine UI framework. Zero Bootstrap, zero Materialize, zero jQuery. Pure red, black, and raw power.

---

## 🔥 Why rde_oxitems?

| Editing items.lua by hand | ✅ rde_oxitems |
|---|---|
| Open VS Code, SSH, or txAdmin file editor | **Full in-game NUI panel** — open with `/oxitems` |
| Restart ox_inventory after every change | **Runtime injection** — changes take effect immediately |
| Items are gone if the file is deleted or reset | **MySQL persistence** — items survive ox_inventory updates |
| No overview of what items exist | **Searchable, paginated item grid** with images and badges |
| Editing JSON/Lua tables by hand | **Tabbed form editor** — Basic, Behavior, Weapon, Client, Server, Advanced |
| Exporting items is copy-pasting from the DB | **Built-in Lua Export Generator** with syntax highlighting |
| No access control | **Triple-layer admin check** — ACE · ox_core groups · SteamID |
| Realtime sync requires a server restart | **Statebag-driven sync** — every open panel updates instantly |
| ox_inventory items only | **Full property coverage** — every ox_inventory item flag supported |

---

## ✨ Features

### 🗄️ Database Persistence

- All items stored in `rde_items` MySQL table with full JSON data
- Table auto-creates on first start — no manual SQL import needed
- Auto-save thread syncs the runtime ox_inventory cache back to the DB every 5 minutes
- Surviving ox_inventory updates: items stay in the DB regardless of what happens to `items.lua`

### 🔄 Runtime Injection

- On resource start, every DB item is injected into ox_inventory via `exports.ox_inventory:Items(name, data)`
- Items are immediately usable — `AddItem`, `RemoveItem`, weight checks, inventory UI, all work without any restart
- Statebag broadcast on every create/update/delete keeps every open admin panel in sync in real time

### ☁️ Import from ox_inventory

- One-click import of every item currently registered in ox_inventory into the rde_items table
- Existing entries are updated, new entries are added — safe to run multiple times
- Use this to bootstrap the DB from your existing items.lua on first setup

### 📝 Tabbed Item Editor

Six tabs covering the complete ox_inventory item specification:

- **Basic** — name, label, weight, description
- **Behavior** — stack, close, allowArmed, consume, degrade
- **Weapon** — weapon flag, ammoname, ammotype, durability
- **Client** — usetime, cancel, export, event, status effects (JSON), animation (JSON), prop (JSON)
- **Server** — server export, server event
- **Advanced** — context menu buttons (JSON array), additional metadata (JSON)

### 📤 Lua Export Generator

- Generates a ready-to-paste Lua block for any or all items in the DB
- Toggle between "all items" and "DB-only items" (items added via rde_oxitems, not imported from ox_inventory)
- Full syntax highlighting in the preview (keywords, strings, numbers, field names, comments)
- Copy to clipboard in one click
- Includes a header comment block with timestamp, item count, and instructions for both `items.lua` and `data_file` integration

### 🖼️ Item Images with Fallback

- Attempts to load each item's image from `nui://ox_inventory/web/images/<name>.png`
- Falls back to `nui://ox_inventory/web/images/default.png`
- If both fail, renders a clean RDWE-UI placeholder icon — no broken image slots

### 🎨 RDWE-UI Interface

- Built entirely on the Red Dragon Web Engine UI framework — zero external dependencies beyond Lucide icons
- Full dark theme with RDE red accent, consistent with all other RDE resources
- Compact, dense item grid — up to 24 items per page, auto-filling to screen width
- Responsive pagination, live search with 260ms debounce, badge system for weapon/consumable/degrade flags
- DB badge on items that originated in the rde_items table (vs imported from ox_inventory)

### 🌍 Bilingual — EN / DE

- All NUI strings, field labels, validation messages, and notifications fully localized in English and German
- Default language configurable via `Config.DefaultLanguage`
- Runtime locale delivery: server sends the locale table to the client on panel open — no hardcoded strings in HTML
- Add any language by extending `Config.Locales` in `config.lua`

---

## 🔄 How Runtime Injection Works

ox_inventory exposes a dual-purpose `Items()` export:

```lua
-- Getter: returns all registered items
local items = exports.ox_inventory:Items()

-- Setter: registers or updates a single item at runtime
exports.ox_inventory:Items(itemName, itemData)
```

rde_oxitems uses the setter on startup to inject every item in the `rde_items` table. From that point, ox_inventory treats those items identically to anything in `items.lua`.

**What the setter CAN do:**

- Register items for use with `AddItem`, `RemoveItem`, weight checks, inventory UI, `client.export`, `client.event`, `server.export`, `server.event`, `buttons`, `status`, `anim`, `prop` — the complete feature set

**What the setter CANNOT do:**

- Write to `items.lua` (that's a file on disk, not a runtime concern)
- Place images in `ox_inventory/web/images/` — images must be added manually
- Survive an `ox_inventory` resource restart unless rde_oxitems also restarts (or starts after it)

**The recommended setup:**

```
ensure rde_oxitems   -- starts after ox_inventory, injects all DB items
```

Items created via rde_oxitems exist in RAM for the session and in the DB permanently. After a server restart, rde_oxitems re-injects them. After an ox_inventory update that wipes `items.lua`, your DB items are unaffected.

---

## 📤 Lua Export Generator

For items that need to be truly permanent — surviving even a complete database wipe or a full server migration — the Lua Export Generator produces a ready-to-paste block:

```lua
-- ════════════════════════════════════════════════════════
-- RDE OX Items Export — generated by rde_oxitems v2.0.0
-- Generated: 2025-06-27 21:00:00
-- Items: 12
-- ════════════════════════════════════════════════════════
-- Paste into: ox_inventory/data/items.lua
-- Or put into ox_inventory/data/rde_items.lua and add:
--   data_file 'data/rde_items.lua'  (in ox_inventory fxmanifest)
-- ════════════════════════════════════════════════════════

    ['my_item'] = {
        label = 'My Item',
        weight = 200,
        stack = true,
        client = {
            usetime = 2500,
            status = {
                hunger = 200000,
            },
            anim = {
                dict = 'mp_player_inteat@burger',
                clip = 'mp_player_int_eat_burger_fp',
            },
        },
    },
```

The `data_file` approach is strongly recommended over editing `items.lua` directly — it keeps your custom items in a separate file that survives ox_inventory updates untouched.

---

## 📦 Dependencies

| Resource | Required | Notes |
|---|---|---|
| `oxmysql` | ✅ Required | Database layer |
| `ox_core` | ✅ Required | Player/character framework + admin group resolution |
| `ox_lib` | ✅ Required | Callbacks, notifications |
| `ox_inventory` | ✅ Required | The inventory system being managed |

---

## 🚀 Installation

### 1. Clone / drop into resources

```bash
cd resources
git clone https://github.com/RedDragonElite/rde_oxitems.git
```

### 2. Add to server.cfg

```
ensure oxmysql
ensure ox_lib
ensure ox_core
ensure ox_inventory
ensure rde_oxitems   # must start AFTER ox_inventory
```

> ⚠️ `rde_oxitems` must start **after** `ox_inventory`. The runtime injection on startup relies on ox_inventory already being fully loaded.

### 3. Database

The `rde_items` table is created automatically on first start. No manual SQL import needed.

### 4. Configure (optional)

Edit `config.lua` to set your admin groups, default language, and database table name.

### 5. Bootstrap from existing items.lua (optional)

Open the panel in-game, click **Import from OX** — every item currently registered in ox_inventory is pulled into the DB. Safe to run on a live server.

### 6. Restart

```
restart rde_oxitems
```

---

## ⚙️ Configuration

```lua
-- Core
Config.Debug               = false
Config.DatabaseTable       = 'rde_items'
Config.StatebagPrefix      = 'rde_oxitems_'
Config.AllowAcePermissions = true
Config.DefaultLanguage     = 'en'   -- 'en' | 'de'

-- Admin groups (ox_core group names)
Config.AdminGroups = {
    ['admin']      = true,
    ['superadmin'] = true,
    ['management'] = true,
    ['owner']      = true,
}

-- Admin ACE permission
Config.Admin = {
    AcePermission = 'rde.oxitems.admin',
    SteamIDs = {
        -- 'steam:110000101605859',
    },
}
```

### Adding a language

```lua
Config.Locales['fr'] = {
    nui_title   = 'Gestionnaire OX Inventory — DB Edition',
    nui_close   = 'Fermer',
    -- ... (copy structure from Config.Locales['en'])
}
Config.DefaultLanguage = 'fr'
```

---

## 🎮 Usage

### Opening the panel

```
/oxitems
```

The panel fetches items, locale, and property definitions from the server — everything is loaded fresh every time. Requires admin permission.

### Creating an item

1. Click the **+** FAB button (bottom right)
2. Fill in **Name** (technical, lowercase+underscores), **Display Name**, **Weight**
3. Use the tabs for client callbacks, server events, weapon properties, advanced metadata
4. Click **Save** — item is injected into ox_inventory immediately and persisted to DB

### Editing an item

Click the edit button on any card. The form opens pre-filled. Name is locked in edit mode — rename by deleting and recreating.

### Deleting an item

Click the delete button → confirm in the dialog. Removes from ox_inventory runtime cache and from the DB.

### Exporting to Lua

Click **Export Lua** in the top bar. Toggle "DB only" or "all items". Copy the output and paste into `ox_inventory/data/items.lua` or your dedicated `rde_items_data.lua` file.

### Importing from ox_inventory

Click **Import from OX** → confirm. Every item registered in ox_inventory at that moment is saved to the DB. Existing DB entries are updated.

---

## 🏗️ Architecture

```
rde_oxitems/
├── fxmanifest.lua
├── config.lua              ← all config + locales (EN/DE) + item property definitions
├── server/
│   └── main.lua            ← complete server authority layer
│                              callbacks, net events, DB, statebag sync, admin check, auto-save
├── client/
│   └── main.lua            ← NUI bridge, statebag listener, ESC handler, command
└── web/
    ├── index.html          ← complete NUI (RDWE-UI, no external CSS/JS beyond Lucide + rdwe-ui.*)
    ├── rdwe-ui.css         ← RDWE-UI framework (not bundled — add from shared RDE assets)
    └── rdwe-ui.js          ← RDWE-UI JS (not bundled — add from shared RDE assets)
```

### Statebag sync

Every mutation (create/update/delete/import) writes a lightweight update object to `GlobalState['rde_oxitems_update']`:

```lua
{ action = 'create',  item = itemData, ts = GetGameTimer() }
{ action = 'update',  item = itemData, ts = GetGameTimer() }
{ action = 'delete',  name = itemName, ts = GetGameTimer() }
{ action = 'reload',               ts = GetGameTimer() }
```

Open client panels listen to this statebag key. Single-item updates (`create`/`update`) apply a lightweight patch — no full re-fetch. Structural changes (`delete`/`reload`) trigger a full re-fetch from the server. This keeps all open panels in sync without polling.

### Admin check — triple layer

```
1. ACE permission (IsPlayerAceAllowed)
2. ox_core group membership (Config.AdminGroups)
3. SteamID whitelist (Config.Admin.SteamIDs)
```

Any layer grants access. All three are checked server-side on every callback and net event. The client cannot bypass this.

---

## 🛡️ Security

- **Every callback and net event checks `IsAdmin(source)` before execution.** The client cannot trigger any mutation without passing the server-side admin check.
- Players who fail the admin check on a mutation net event are **dropped** from the server (not just notified).
- Notification dedup prevents spam — the same notification cannot fire for the same player more than once per 2 seconds.
- Item names passed from the client are validated server-side before being passed to ox_inventory or the DB.
- JSON fields (`client`, `server`, `buttons`, `metadata`) are stored as JSON strings in the DB and parsed server-side before injection — malformed JSON is caught and rejected, not executed.
- The export admin permission (`exports('isAdmin', IsAdmin)`) is available to other RDE resources for consistent admin gating across the ecosystem.

---

## 📋 Commands

| Command | Restricted | Description |
|---|---|---|
| `/oxitems` | Admin | Open the OX Inventory Item Manager panel |

---

## 🗄️ Database

| Table | Purpose |
|---|---|
| `rde_items` | Item storage — `name` (PK), `data` (JSON), `updated_at` (auto timestamp) |

The table is created with `CREATE TABLE IF NOT EXISTS` on resource start. `updated_at` is set automatically on every row update via `ON UPDATE CURRENT_TIMESTAMP`.

The `data` column stores the complete item object as JSON — every ox_inventory property, including nested `client`, `server`, `buttons`, and `metadata` sub-objects. The DB is the source of truth; ox_inventory's runtime cache is always derived from it.

---

## ⚡ Performance

**Startup injection:** items are injected into ox_inventory one at a time via the `Items()` setter. For typical item counts (100–500 items), startup injection takes under 100ms. For very large item sets (1000+), consider the `data_file` approach for startup load.

**Auto-save thread:** runs every 5 minutes, writing only items currently in the ox_inventory runtime cache. Runs on a CreateThread — no blocking.

**Statebag sync:** one statebag key (`rde_oxitems_update`) for the entire resource. Writes contain only the changed item or action type — not the full item list. Full re-fetches are triggered client-side only when necessary (delete/reload actions).

**Search:** debounced at 260ms client-side, filtering in-memory — zero server round-trips for search.

**Notification dedup:** a server-side cache prevents duplicate notifications from firing within a 2-second window. Cache is cleaned up every 10 minutes.

---

## 🐛 Troubleshooting

**`attempt to index a nil value (global 'Config')`**
`config.lua` must declare `Config = {}` as a global (no `local`). FiveM's `shared_scripts` runs files in a shared scope — `local` makes the variable invisible to other files, and `return Config` is silently ignored. If you see this error, check that the first line of `config.lua` is `Config = {}`, not `local Config = {}`.

**Panel doesn't open?**
Check F8 console for errors on the client side. Confirm you have admin permission (ACE, ox_core group, or SteamID). Confirm `ox_inventory` is started before `rde_oxitems` in `server.cfg`.

**Items not persisting after restart?**
Check that `oxmysql` is running and the `rde_items` table exists. Set `Config.Debug = true` and check the server console for `[RDE OXITEMS]` log lines during startup injection.

**NUI shows no styling (raw HTML)?**
`rdwe-ui.css` and `rdwe-ui.js` are not bundled. Copy them into `rde_oxitems/web/` from your RDWE-UI assets. Both are declared in `fxmanifest.lua` under `files {}`.

**Import from OX imports 0 items?**
ox_inventory must be fully started before the import fires. Check that `ox_inventory` starts before `rde_oxitems` in `server.cfg`.

**Items created in-game vanish after `restart ox_inventory`?**
This is expected — the `Items()` setter only affects the runtime cache. After restarting ox_inventory, restart rde_oxitems as well (or restart both together). For permanent items, use the Lua Export Generator and the `data_file` approach.

**`attempt to call a nil value (global 'Ox')`**
ox_core must be started before rde_oxitems. The startup thread waits up to 10 seconds for `Ox` to be available before aborting. Check your `server.cfg` start order.

---

## 📝 Changelog

### v2.0.0 — Full Rewrite

**Complete rewrite from the original rde_oxitems.**

- Replaced Materialize CSS with **RDWE-UI** — the RDE-native CSS/JS framework. Zero Bootstrap, zero jQuery, zero Materialize.
- Replaced hardcoded German strings with a **full bilingual locale system** (EN/DE). All NUI text, field labels, validation messages, and server notifications are locale-driven. Language delivered from server on panel open.
- Fixed **`local Config = {}` / `return Config`** bug — was causing `attempt to index a nil value (global 'Config')` on startup. Config is now a proper FiveM global.
- Fixed **`Wait()` in event handler** — the ox_core availability check in `onResourceStart` is now wrapped in `CreateThread` so `Wait()` is valid.
- Fixed **item image broken state** — the original left an empty slot when both the item image and the default image failed to load. Now renders an RDWE-UI placeholder icon.
- Fixed **XSS vector in card rendering** — item data was embedded in `data-item` attributes without escaping. Now uses `encodeURIComponent` + `decodeURIComponent` + `escapeHtml`.
- Fixed **`GlobalState` abuse** — the original broadcast the entire items table (~300+ items) on every operation. Now broadcasts only a lightweight `{action, item, ts}` object; clients re-fetch only when necessary.
- Fixed **`Wait(0)` performance issue** — the ESC key detection thread was running at 60Hz. Now runs at 100ms poll (still instant for UI purposes, zero gameplay impact).
- Added **Lua Export Generator** with syntax highlighting, DB-only filter, and clipboard copy.
- Added **statebag-driven realtime sync** — single item updates apply a lightweight patch; structural changes trigger a targeted re-fetch.
- Added **triple-layer admin check** — ACE · ox_core groups · SteamID, checked server-side on every callback and net event.
- Added **notification dedup** — prevents spam notifications within a 2-second window.
- Added **auto-save thread** — syncs the ox_inventory runtime cache back to the DB every 5 minutes.
- Added **`exports('isAdmin', IsAdmin)`** — other RDE resources can use the same admin check.
- Added **DB badge** on item cards — visually distinguishes items that originated in rde_items (created via the panel) from items imported from ox_inventory.

---

## 🙏 Contributors & Credits

| | |
|---|---|
| 🐉 **SerpentsByte** | Architect & developer |

---

## 📜 License

```
###################################################################################
# .:: RED DRAGON ELITE (RDE) - BLACK FLAG SOURCE LICENSE v6.66 ::.
# PROJECT: RDE_OXITEMS v2.0.0 (OX INVENTORY ITEM MANAGER — DB EDITION)
# ARCHITECT: .:: RDE ⧌ Shin [△ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽] ::. | https://rd-elite.com
# ORIGIN: https://github.com/RedDragonElite
#
# [ THE RULES OF THE GAME ]
#
# 1. // THE "FUCK GREED" PROTOCOL (FREE USE)
#    You are free to use, edit, and abuse this code on your server.
#    Learn from it. Break it. Fix it. That is the hacker way.
#    Cost: 0.00€. If you paid for this, you got scammed by a rat.
#
# 2. // THE TEBEX KILL SWITCH (COMMERCIAL SUICIDE)
#    If I find this script on Tebex, Patreon, or in a paid "Premium Pack":
#    > I will DMCA your store into oblivion.
#    > I will publicly shame your community.
#    SELLING FREE WORK IS THEFT. AND I AM THE JUDGE.
#
# 3. // THE CREDIT OATH
#    Keep this header. If you remove my name, you admit you have no skill.
#    You can add "Edited by [YourName]", but never erase the original creator.
#    Don't be a skid. Respect the architecture.
#
# 4. // THE CURSE OF THE COPY-PASTE
#    This resource uses runtime ox_inventory injection via the Items() setter.
#    If you copy-paste without understanding the local Config / return Config
#    FiveM scope bug, you will ship a resource that errors on line 9 and
#    silently fails every admin check. RTFM. Read the changelog. Then code.
#
# "We build the future on the graves of paid resources."
# "REJECT MODERN MEDIOCRITY. EMBRACE RDE SUPERIORITY."
###################################################################################
```

---

## 🌐 Community & Support

| | |
|---|---|
| 🐙 GitHub | [RedDragonElite](https://github.com/RedDragonElite) |
| 🌍 Website | [rd-elite.com](https://rd-elite.com) |
| 🏢 RDE Organizations | [rde_organizations](https://github.com/RedDragonElite/rde_organizations) |
| 🚗 RDE Parking | [rde_parking](https://github.com/RedDragonElite/rde_parking) |
| 🚪 RDE Doors | [rde_doors](https://github.com/RedDragonElite/rde_doors) |
| 🚨 RDE AIPD | [rde_aipd](https://github.com/RedDragonElite/rde_aipd) |
| 🏥 RDE AIMD | [rde_aimd](https://github.com/RedDragonElite/rde_aimd) |

When asking for help, always include:
- Full error from server console or txAdmin
- Your `server.cfg` resource start order (especially ox_inventory vs rde_oxitems position)
- ox_core / ox_lib / ox_inventory versions in use
- `Config.Debug = true` output if the issue is injection or admin-check related

---

> *"No more SSH sessions to edit items.lua at 2am.*
> *Create, edit, export — all in-game. All persistent. All free."*
>
> **REJECT MODERN MEDIOCRITY. EMBRACE RDE SUPERIORITY.**

[![Website](https://img.shields.io/badge/Website-Visit-red?style=for-the-badge&logo=google-chrome)](https://rd-elite.com)
[![Nostr](https://img.shields.io/badge/Nostr-Follow-purple?style=for-the-badge&logo=rss)](https://primal.net/p/npub1wr4e24zn6zzjqx8kvnelfvktf0pu6l2gx4gvw06zead2eqyn23sq9tsd94)
[![RDE Ecosystem](https://img.shields.io/badge/RDE-ECOSYSTEM-f59e0b?style=for-the-badge)](https://github.com/RedDragonElite)

🐉 *Made with 🔥 by Red Dragon Elite*

[⬆ Back to Top](#-rde_oxitems)
