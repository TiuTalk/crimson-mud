# Crimson MUD Roadmap

## Scope

CircleMUD / DikuMUD-inspired Ruby MUD server implementing classic MUD features.

**Core goals:** rooms, navigation, multiplayer, communication, zones, mobs
**Future goals:** inventory, combat, persistence, skills
**Non-goals:** admin commands, authentication, building commands

## Phase 1: Command System

- [x] Command parser (split input into command + args)
- [x] Command dispatcher/registry
- [x] `commands` - list available commands
- [x] `quit` - clean disconnect (enhance existing)

## Phase 2: World Foundation

- [x] Room class (name, description)
- [ ] Room exits hash
- [ ] In-memory world with hardcoded rooms (3-5 connected)
- [x] `look` - show current room description
- [ ] `look` - show exits

## Phase 3: Players

- [x] Player class (name, current_room)
- [x] Player registry (track connected players)
- [x] Login flow (name selection, no password)
- [x] Place player in starting room on connect
- [x] `look` - include other players in room
- [ ] `who` - list connected players

## Phase 4: Navigation

- [ ] `n`, `s`, `e`, `w` - directional movement
- [ ] Exit validation + error messages
- [ ] Broadcast arrivals/departures to room

## Phase 5: Communication

- [x] `say <message>` - broadcast to current room
- [x] `tell <player> <message>` - private message

## Phase 6: Zones/Areas

- [ ] Zone class (id, name, rooms, reset timer)
- [ ] Load zones from data files
- [ ] Zone reset mechanism
- [ ] Connect rooms across zones

## Phase 7: NPCs/Mobs

- [ ] Mobile class (name, description, stats)
- [ ] Mob spawning on zone reset
- [ ] Basic AI (wandering, returning home)
- [ ] Aggro behavior
- [ ] `look` - show mobs in room

## Phase 8: Inventory (Future)

- [ ] Object class (id, name, description, location)
- [ ] `inventory` - list carried objects
- [ ] `get <object>` - pick up from room
- [ ] `drop <object>` - leave in room

## Phase 9: Combat (Future)

- [ ] HP/stats on players
- [ ] `kill <target>` - initiate combat
- [ ] Combat rounds + damage
- [ ] `flee` - escape combat
- [ ] Death + respawn

## Phase 10: Persistence (Future)

- [ ] SQLite database + migrations
- [ ] Save/load zones + rooms
- [ ] Save/load players
- [ ] Save/load objects + mobs
