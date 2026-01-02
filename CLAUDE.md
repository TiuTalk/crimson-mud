# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Multi-User Dungeon (MUD) server written in Ruby. Uses Zeitwerk for autoloading.

## Commands

```bash
# Run server (telnet 0.0.0.0:4000)
bundle exec bin/server

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

### Configuration
- `Mud.configure { |c| ... }` - Block-style configuration
- `Mud.logger` - Centralized logger access
- `Mud.server` - Returns `Mud::Telnet::Server.instance` (Singleton)

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
