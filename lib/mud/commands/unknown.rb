# frozen_string_literal: true

module Mud
  module Commands
    class Unknown < Base
      def initialize(player:, args:, name:)
        super(player:, args:)
        @name = name
      end

      def execute
        @player.puts("Unknown command: #{@name}")
      end
    end
  end
end
