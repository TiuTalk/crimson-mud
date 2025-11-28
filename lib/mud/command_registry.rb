# frozen_string_literal: true

module Mud
  module CommandRegistry
    COMMANDS = {
      'say' => Commands::Say,
      'quit' => Commands::Quit
    }.freeze

    def self.execute(input, player:)
      name, args = parse(input)
      command_class = COMMANDS[name]

      if command_class
        command_class.new(player:, args:).execute
      else
        player.puts("Unknown command: #{name}")
      end
    end

    def self.parse(input)
      parts = input.to_s.split(/\s+/, 2)
      [parts[0]&.downcase, parts[1] || '']
    end
  end
end
