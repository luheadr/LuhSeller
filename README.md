# LuhSeller

Auto-sell addon for **World of Warcraft 3.3.5a (WotLK)**.

## Features

- Auto-sell when opening a vendor (with master on/off toggle)
- Sell grey, white, green soulbound equipment, and blue soulbound non-equipment items (all on by default)
- Auto-restock from vendors with per-item target quantity (defaults to stack size)
- Whitelist (never sell), sell list (always sell), and restock list
- Drag-and-drop, item link, ID, or name to manage lists
- Searchable lists with remove support
- Minimap button and slash commands

## Install

1. Copy the `LuhSeller` folder into `Interface\AddOns\`
2. Enable the addon on the character select screen
3. `/reload` or restart the client

## Commands

| Command | Action |
|---|---|
| `/ls` or `/luhseller` | Open settings |
| `/ls toggle` | Toggle auto-sell |
| `/ls sell` | Sell now (at vendor) |
| `/ls restock` | Restock now (at vendor) |

## Safety

Never sells quest items, keys, or items with no vendor price.

**Priority:** whitelist → sell list → checkbox rules.

## License

MIT
