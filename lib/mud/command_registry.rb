# frozen_string_literal: true

module Mud
  module CommandRegistry
    COMMANDS = {
      'say' => Commands::Say,
      'quit' => Commands::Quit
    }.freeze

    def self.execute(input, player:)
      name, args = parse(input)
      command_class = COMMANDS.fetch(name, Commands::Unknown)

      if command_class == Commands::Unknown
        command_class.new(player:, args:, name:).execute
      else
        command_class.new(player:, args:).execute
      end
    end

    def self.parse(input)
      parts = input.to_s.split(/\s+/, 2)
      [parts[0]&.downcase, parts[1] || '']
    end
  end
end
