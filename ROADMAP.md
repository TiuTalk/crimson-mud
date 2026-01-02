# Crimson MUD Roadmap

## Scope

Ruby MUD server targeting [TinyMUD](https://github.com/nickgammon/tinymudserver) feature parity with CircleMUD-style command output formatting.

**Core goals:** rooms, navigation, multiplayer, communication
**Future goals:** inventory, combat, persistence
**Non-goals:** admin commands, authentication, building commands

## Phase 1: Command System

- [x] Command parser (split input into command + args)
- [x] Command dispatcher/registry
- [x] `commands` - list available commands
- [x] `quit` - clean disconnect (enhance existing)

## Phase 2: World Foundation

- [ ] Room class (id, name, description, exits hash)
- [ ] In-memory world with hardcoded rooms (3-5 connected)
- [ ] `look` - show current room description + exits

## Phase 3: Players

- [ ] Player class (name, current_room)
- [x] Player registry (track connected players)
- [ ] Login flow (name selection, no password)
- [ ] Place player in starting room on connect
- [ ] `look` - include other players in room
- [ ] `who` - list connected players

## Phase 4: Navigation

- [ ] `n`, `s`, `e`, `w` - directional movement
- [ ] Exit validation + error messages
- [ ] Broadcast arrivals/departures to room

## Phase 5: Communication

- [x] `say <message>` - broadcast to current room
- [ ] `tell <player> <message>` - private message

## Phase 6: Inventory (Future)

- [ ] Object class (id, name, description, location)
- [ ] `inventory` - list carried objects
- [ ] `get <object>` - pick up from room
- [ ] `drop <object>` - leave in room

## Phase 7: Combat (Future)

- [ ] HP/stats on players
- [ ] `kill <player>` - basic combat
- [ ] `flee` - escape combat
- [ ] Death + respawn

## Phase 8: Persistence (Future)

- [ ] SQLite database + migrations
- [ ] Save/load rooms
- [ ] Save/load players
- [ ] Save/load objects
