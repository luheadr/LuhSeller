# LuhUtilities

Auto-sell, restock, and group loot rolling for **World of Warcraft 3.3.5a (WotLK)**.

Formerly **LuhSeller** — existing character settings migrate automatically from `LuhSellerDB` to `LuhUtilitiesDB`.

## Features

### Vendor
- Auto-sell when opening a vendor (with master on/off toggle)
- Sell grey, white, green soulbound equipment, and blue soulbound equipment you can't use
- Auto-restock from vendors with per-item target quantity (defaults to stack size)
- Whitelist (never sell), sell list (always sell), and restock list
- Shows total gold earned after selling

### Group loot rolling
- Auto-roll when in a party or raid
- **Green:** DE first (default), Greed first, or Greed only (no DE)
- **Blue equipment:** Auto-greed when you can't equip it, with per armor-type toggles
- **Epic equipment:** Auto-DE when you can't equip it (off by default)
- **Recipes:** Need on usable, Greed on unusable
- **Roll List:** Force Need / Greed / Pass / DE per item (highest priority)

### General
- Drag-and-drop, item link, ID, or name to manage lists
- Searchable lists with remove support
- Minimap button and slash commands

## Install

1. Copy the `LuhUtilities` folder into `Interface\AddOns\`
2. Disable the old `LuhSeller` addon if still present
3. Enable **LuhUtilities** on the character select screen
4. `/reload` or restart the client

## Commands

| Command | Action |
|---|---|
| `/lu` or `/luhutilities` | Open settings |
| `/ls` or `/luhseller` | Open settings (legacy alias) |
| `/lu toggle` | Toggle auto-sell |
| `/lu sell` | Sell now (at vendor) |
| `/lu restock` | Restock now (at vendor) |

## License

MIT
