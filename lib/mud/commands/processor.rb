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
        method_name = "cmd_#{command}"

        if respond_to?(method_name, true)
          send(method_name, args)
        else
          player.puts("Unknown command: #{command}")
        end
      end

      private

      def parse(input)
        parts = input.strip.split(' ', 2)
        [parts[0], parts[1].to_s]
      end

      def cmd_quit(_args)
        player.quit
      end

      def cmd_say(args)
        message = args.strip
        player.puts("You say '#{message}'")
        Mud.server.broadcast("Someone says '#{message}'", except: player)
      end
    end
  end
end
