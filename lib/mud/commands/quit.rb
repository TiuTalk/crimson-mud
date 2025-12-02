# frozen_string_literal: true

module Mud
  module Commands
    class Quit < Base
      command :quit

      def perform
        player.quit
      end
    end
  end
end
