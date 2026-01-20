# frozen_string_literal: true

module Mud
  module Commands
    class Tell < Base
      command :tell, args: 2, usage: 'Tell whom what?'

      validate :target_exists
      validate :not_self

      def perform
        player.puts("&mYou tell #{target.name}, '#{message}'")
        target.puts("&m#{player.name} tells you, '#{message}'")
      end

      private

      def target_name = args[0]
      def message = args[1..].join(' ')

      def target
        @target ||= Mud.world.players.find { |p| p.name.casecmp?(target_name) }
      end

      def target_exists
        'No player by that name is connected.' unless target
      end

      def not_self
        'Talking to yourself again?' if target == player
      end
    end
  end
end
