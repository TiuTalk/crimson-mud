# Crimson MUD

[![Build](https://github.com/TiuTalk/crimson-mud/actions/workflows/main.yml/badge.svg)](https://github.com/TiuTalk/crimson-mud/actions/workflows/main.yml)

Ruby MUD server targeting [TinyMUD](https://github.com/nickgammon/tinymudserver) feature parity with [CircleMUD](https://www.circlemud.org/)-style output formatting.

## Requirements

- Ruby >= 3.2

## Installation

```bash
bundle install
```

## Usage

```bash
bundle exec bin/server
```

Starts telnet server on `0.0.0.0:4000`.

## Development

```bash
bundle exec rspec
bundle exec rubocop
```

## Roadmap

See [ROADMAP.md](ROADMAP.md)

## License

MIT
