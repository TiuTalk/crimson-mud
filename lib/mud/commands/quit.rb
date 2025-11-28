# frozen_string_literal: true

module Mud
  module Commands
    class Quit < Base
      def execute
        @player.quit
      end
    end
  end
end
