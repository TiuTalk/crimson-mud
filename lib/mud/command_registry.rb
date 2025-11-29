# frozen_string_literal: true

module Mud
  module CommandRegistry
    @commands = {}

    def self.register(klass, name, aliases: [])
      @commands[name.to_s] = klass
      aliases.each { |a| @commands[a.to_s] = klass }
    end

    def self.find(name)
      @commands[name]
    end

    def self.execute(input, player:)
      name, args = parse(input)
      command_class = find(name)

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
