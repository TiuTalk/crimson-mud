# frozen_string_literal: true

require 'singleton'

module Mud
  class World
    include Singleton
    include HasPlayers

    def add_player(player)
      super
      player.room.add_player(player)
    end

    def remove_player(player)
      player.room.remove_player(player)
      super
    end

    def clear
      @players_mutex.synchronize { @players.clear }
    end
  end
end
