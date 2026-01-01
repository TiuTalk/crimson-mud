# frozen_string_literal: true

module Mud
  module Commands
    class Say < Base
      command :say

      def perform(args)
        message = args.strip
        player.puts("You say '#{message}'")
        server.broadcast("Someone says '#{message}'", except: player)
      end
    end
  end
end
