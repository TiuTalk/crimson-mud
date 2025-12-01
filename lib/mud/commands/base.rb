# frozen_string_literal: true

module Mud
  module Commands
    class Base
      attr_reader :player, :args

      def self.command(name, aliases: [])
        CommandRegistry.register(self, name, aliases:)
      end

      def initialize(player:, args:)
        @player = player
        @args = args
      end

      def execute
        raise NotImplementedError
      end

      private

      def server
        Server.instance
      end
    end
  end
end
