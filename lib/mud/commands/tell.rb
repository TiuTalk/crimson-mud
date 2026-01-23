# frozen_string_literal: true

module Mud
  module Commands
    class Tell < Base
      command :tell, args: 2, usage: 'Tell whom what?'

      validate :target_exists

      def perform
        Actions::Tell.execute(actor:, target:, message:)
      end

      private

      def message = Color.strip(args[1..].join(' '))

      def target
        @target ||= Mud.world.players(except: player).find { |p| p.name.casecmp?(args[0]) }
      end

      def target_exists
        'No player by that name is connected.' unless target
      end
    end
  end
end
