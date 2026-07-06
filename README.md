# LuhSeller

Auto-sell addon for **World of Warcraft 3.3.5a (WotLK)**.

## Features

- Auto-sell when opening a vendor (with master on/off toggle)
- Sell grey items (on by default)
- Sell white equipment
- Sell green soulbound equipment
- Whitelist (never sell) and sell list (always sell)
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

## Safety

Never sells quest items, keys, or items with no vendor price.

**Priority:** whitelist → sell list → checkbox rules.

## License

MIT
