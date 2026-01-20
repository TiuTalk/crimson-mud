# frozen_string_literal: true

module Mud
  module Commands
    class Processor
      attr_reader :player

      def initialize(player:)
        @player = player
      end

      def process(input)
        return if input.strip.empty?

        command, args = input.strip.split(/\s+/, 2)
        command_class = Registry.lookup(command.downcase)

        if command_class
          command_class.execute(player, args)
        else
          player.puts("Unknown command: #{command}")
        end
      end
    end
  end
end
