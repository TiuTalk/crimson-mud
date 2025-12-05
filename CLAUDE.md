# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

MUD (multi-user dungeon) server written in Ruby. Packaged as a gem.

## Commands

```bash
# Install dependencies
bin/setup

# Run tests
bundle exec rspec --format progress
bundle exec rspec --format progress spec/path/to/spec.rb
bundle exec rspec --format progress spec/path/to/spec.rb:42
COVERAGE=1 bundle exec rspec --format progress # Run tests with coverage

# Linters
bundle exec rubocop
bundle exec rubocop --autocorrect-all
```

## Architecture

- Ruby 3.2+
- Zeitwerk autoloading
- `lib/mud.rb` - Entry point, `Mud` module with configuration and logger
- `lib/mud/configuration.rb` - Configuration object
- `lib/mud/network/telnet_server.rb` - TCP server, accepts connections
- `lib/mud/network/client.rb` - Socket wrapper for single client
- `lib/mud/server.rb` - Application server (singleton), orchestrates connections
- `lib/mud/player.rb` - Player entity, wraps client with name/identity
- `lib/mud/command_registry.rb` - Parses input and dispatches to command classes
- `lib/mud/commands/` - Command classes using Template Method pattern (Base, Say, Quit)
- `spec/` - RSpec tests mirroring lib structure

### Message Flow

```
TelnetServer (TCP) → Server#handle_connection → Player#run
  → CommandRegistry.execute → Commands::* → Player/Server
```

### Adding Commands

Commands use Template Method pattern. Create in `lib/mud/commands/`:

```ruby
class MyCommand < Base
  command :mycommand, aliases: %i[mc]  # Registers with CommandRegistry

  def perform  # Override this, not execute
    player.puts("output")
    server.broadcast("message", except: player)
  end
end
```

- `execute` handles logging, calls `perform`
- Access `player`, `args`, `server` from base class

## Design Principles

### Core
- **SRP (Single Responsibility)** - One reason to change per class/module
- **OCP (Open/Closed)** - Extend via composition, not modification
- **YAGNI (You Ain't Gonna Need It)** - Don't build until needed
- **DRY (Don't Repeat Yourself)** - Extract only after 3+ duplications
- **KISS (Keep It Simple, Stupid)** - Simplest solution that works

### Ruby Idioms
- **Composition over Inheritance** - Prefer modules and delegation
- **Tell, Don't Ask** - Command objects to act, don't query then decide
- **Law of Demeter** - Only talk to immediate collaborators

## TDD (Test-Driven Development)

TDD is required for all new code and when updating existing code, if feasible.

- **Red-Green-Refactor** - Write failing spec → make it pass → refactor
- **Smallest Change** - Minimal code to pass each test
- **One Failing Test** - Don't write multiple failing specs before implementing
- **Test Public Behavior** - Test public interface, not implementation details

### Testing

- Don't manually test servers/networking - rely on specs
- Avoid background processes that require cleanup
