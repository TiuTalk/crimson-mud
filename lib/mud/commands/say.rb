# frozen_string_literal: true

module Mud
  module Commands
    class Say < Base
      command :say

      def perform
        player.puts("&cYou say '#{message}'")
        room.broadcast("&c#{player.name} says '#{message}'", except: player)
      end

      private

      def message = Color.strip(args.join(' '))
    end
  end
end
