# frozen_string_literal: true

module Mud
  module Commands
    class Say < Base
      command :say, aliases: %i[']

      def perform
        player.puts("You say, '#{args}'")
        server.broadcast("#{player.name} says, '#{args}'", except: player)
      end
    end
  end
end
