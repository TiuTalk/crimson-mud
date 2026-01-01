# frozen_string_literal: true

module Mud
  module Commands
    class Processor
      attr_reader :player

      def initialize(player:)
        @player = player
      end

      def process(input)
        command, args = parse(input)
        command_class = Registry.lookup(command.downcase)

        if command_class
          command_class.new(player:).execute(args:)
        else
          player.puts("Unknown command: #{command}")
        end
      end

      private

      def parse(input)
        parts = input.strip.split(' ', 2)
        [parts[0], parts[1].to_s]
      end
    end
  end
end
