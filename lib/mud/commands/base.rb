# frozen_string_literal: true

module Mud
  module Commands
    class Base
      def initialize(player:, args:)
        @player = player
        @args = args
      end

      def execute
        raise NotImplementedError
      end
    end
  end
end
