# frozen_string_literal: true

module Mud
  module Commands
    class Base
      class << self
        def command(*keywords)
          Registry.register(*keywords, self)
        end

        def execute(player, args = '')
          new(player:).execute(args:)
        end
      end

      def initialize(player:)
        @player = player
      end

      def execute(args:)
        Mud.logger.debug("#{player.name} executing: #{self.class.name}")
        perform(args)
      end

      private

      attr_reader :player

      def perform(_args)
        raise NotImplementedError, "#{self.class}#perform must be implemented"
      end

      def room = player.room
    end
  end
end
