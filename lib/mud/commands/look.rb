# frozen_string_literal: true

module Mud
  module Commands
    class Look < Base
      command :look

      def perform(_args)
        player.puts(<<~OUTPUT.chomp)
          &c#{player.room.name}&n
          #{player.room.description}
        OUTPUT
      end
    end
  end
end
