# frozen_string_literal: true

module Mud
  module Commands
    class Say < Base
      command :say, aliases: %i[']

      def perform
        escaped = Colors.escape(args)
        player.puts("&cYou say, '#{escaped}'")
        server.broadcast("&c#{player.name} says, '#{escaped}'", except: player)
      end
    end
  end
end
