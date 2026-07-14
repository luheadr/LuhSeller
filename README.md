# LuhUtilities

Utility addon for **World of Warcraft 3.3.5a (WotLK)** — vendors, loot rolling, mounts, gossip, and player alerts.

## Features

### Vendor
- Auto-sell and auto-restock at vendors
- Quality-based sell rules, whitelist, sell list, and restock list
- Prompt to save manually sold items to the sell list

### Group loot rolling
- Auto-roll in parties and raids with quality-based rules
- Force-list overrides (Need / Greed with DE-first / Pass / DE)
- Prompt to save manually rolled items to the force list

### Mount
- Smart ground/flying/passenger mount selection (GoGoMount-style)

### Gossip
- Auto-select vendor, banker, trainer, flight, stable, and battlemaster gossip
- Saved NPC list; Shift skips automation

### Blacklist
- Alert when blacklisted players are nearby (party, raid, target)

### General
- Searchable item and NPC lists with drag-and-drop support
- Minimap button and slash commands

## Install

1. Copy the `LuhUtilities` folder into `Interface\AddOns\`
2. Enable **LuhUtilities** on the character select screen
3. `/reload` or restart the client

## Commands

| Command | Action |
|---|---|
| `/lu` or `/luhutilities` | Open settings |
| `/lu toggle` | Toggle auto-sell |
| `/lu sell` | Sell now (at vendor) |
| `/lu restock` | Restock now (at vendor) |
| `/lu mount` | Open mount settings |
| `/lu bl` | Blacklist commands |

## License

MIT
