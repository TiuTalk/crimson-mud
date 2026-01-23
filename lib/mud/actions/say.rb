# frozen_string_literal: true

module Mud
  module Actions
    class Say < Base
      def perform(message:)
        actor.puts("&cYou say '#{message}'")
        room.broadcast("&c#{actor.name} says '#{message}'", except: actor)
      end
    end
  end
end
