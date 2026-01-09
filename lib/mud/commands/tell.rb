# frozen_string_literal: true

module Mud
  module Commands
    class Tell < Base
      command :tell

      def perform(args)
        target_name, message = parse_args(args)
        return unless message

        target = find_target(target_name)
        return unless target

        player.puts("&mYou tell #{target.name}, '#{message}'")
        target.puts("&m#{player.name} tells you, '#{message}'")
      end

      private

      def parse_args(args)
        parts = args.strip.split(/\s+/, 2)
        return player.puts('Tell whom what?') if parts.size < 2

        parts
      end

      def find_target(name)
        target = Mud.world.players.find { |p| p.name.casecmp?(name) }
        return player.puts('No player by that name is connected.') unless target
        return player.puts('Talking to yourself again?') if target == player

        target
      end
    end
  end
end
