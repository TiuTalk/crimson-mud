# frozen_string_literal: true

module Mud
  module Commands
    class Say < Base
      def execute
        @player.puts("You say, '#{@args}'")
        Server.instance.broadcast("#{@player.name} says, '#{@args}'", except: @player)
      end
    end
  end
end
