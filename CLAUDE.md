# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Multi-User Dungeon (MUD) server written in Ruby. Uses Zeitwerk for autoloading.

[CircleMUD](https://github.com/Yuffster/CircleMUD) / [DikuMUD](https://github.com/Seifert69/DikuMUD)-inspired with classic output formatting. See [ROADMAP.md](ROADMAP.md) for goals.

## Commands

```bash
# Tests
bundle exec rspec
bundle exec rspec spec/file_spec.rb
bundle exec rspec spec/file_spec.rb:42

# Linters
bundle exec rubocop --format=simple --autocorrect-all
```

## Architecture

- `lib/mud.rb` - Entry point, sets up Zeitwerk autoloader
- `lib/mud/` - All module code, autoloaded
- `spec/` - RSpec tests mirror `lib/` structure

### Telnet Module
- `Mud::Telnet::Server` - TCP server, spawns thread per client connection
- `Mud::Telnet::Client` - Wraps socket I/O with Forwardable delegation

### Player
- `Mud::Player` - Game loop per connection, delegates I/O to Client

### Commands
- `Mud::Commands::Base` - Inherit to create commands, use `command :keyword` DSL to register
- `Mud::Commands::Registry` - Stores commands, supports abbreviations via `Abbrev`
- `Mud::Commands::Processor` - Parses input, looks up command in Registry, executes

### Actions
- `Mud::Actions::Base` - Inherit, implement `#perform` with action-specific params
- `.execute(actor:, **args)` → `new(actor:).perform(**args)`
- Base handles `actor:` init, provides `#room` helper via `actor.room`
- Commands parse/validate, then delegate to Actions
- Naming: `actor:` (who performs), `target:` (who receives), `message:`

### World & Rooms
- `Mud::World` - Singleton for centralized player/room tracking
- `Mud::Room` - Room model with player management
- `Mud::Concerns::HasPlayers` - Shared mixin for player tracking (used by World and Room)

### Color
- `Mud::Color` - ANSI color codes using `&c` syntax (e.g., `&R` red, `&n` reset)

### Configuration
- `Mud.configure { |c| ... }` - Block-style configuration
- `Mud.logger` - Centralized logger access
- `Mud.server` - Returns `Mud::Telnet::Server.instance` (Singleton)
- `Mud.world` - Returns `Mud::World.instance` (Singleton)

## Code Standards

- **YAGNI** - Don't build it until you need it
- **DRY** - Extract duplication only after it appears 3+ times
- **Composition over inheritance** - Prefer delegation and modules over class hierarchies
- **Single Responsibility** - Classes/methods do one thing well
- **Explicit over implicit** - Favor clarity over cleverness

## TDD - Test Driven Development

1. **Red** - Write failing spec first
2. **Green** - Minimal code to pass
3. **Refactor** - Clean up, keep tests green

## Testing Guidance

- Never use `instance_variable_set/get` in specs
- Name game objects with personas (alice/bob) not numbers (player1/player2)
- No specs for simple #initialize methods
- Prefer real objects over mocks (except IO/external systems)
- Happy path specs first, error cases after
- When testing new behavior of existing methods, add to existing describe/context blocks

### RSpec

- Write least amount of tests covering most scenarios
- Use `it { is_expected.to be_<predicate> }` for predicate methods
- Use inline `before { }` if one line

### Shared Examples
- Located in `spec/support/shared_examples/`
- Use `it_behaves_like 'a registered command', 'keyword'` for command registration tests

## Code Style

- Use `attr_accessor/reader/writer` over manual getters/setters
- Avoid `instance_variable_get/set`
