# frozen_string_literal: true

module Mud
  module Commands
    class Look < Base
      command :look

      def perform
        player.puts(<<~OUTPUT.strip)
          #{room_header}
          #{room_description}
          #{players_list}
        OUTPUT
      end

      private

      def room_header
        "&c#{room.name}&n"
      end

      def room_description
        room.description
      end

      def players_list
        others = room.players.reject { |p| p == player }
        others.map { |p| "&y#{p.name} is here." }.join("\n")
      end
    end
  end
end
