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

# Lint
bundle exec rubocop

# Lint with auto-fix
bundle exec rubocop --autocorrect-all
```

## Architecture

- Ruby 3.2+
- Zeitwerk autoloading
- `lib/mud.rb` - Entry point, `Mud` module with logger
- `lib/mud/network/server.rb` - TCP server, manages clients, broadcasts messages
- `lib/mud/network/client.rb` - Handles single client connection
- `spec/` - RSpec tests mirroring lib structure

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
