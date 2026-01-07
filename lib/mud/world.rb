# frozen_string_literal: true

require 'singleton'

module Mud
  class World
    include Singleton

    attr_reader :players

    def initialize
      @players = Set.new
      @players_mutex = Mutex.new
    end

    def add_player(player)
      @players_mutex.synchronize { @players.add(player) }
      player.room.add_player(player)
    end

    def remove_player(player)
      player.room.remove_player(player)
      @players_mutex.synchronize { @players.delete(player) }
    end

    def broadcast(message, except: nil)
      players = @players_mutex.synchronize { @players.dup }
      players.each do |player|
        next if player == except

        player.puts(message)
      end
    end

    def clear
      @players_mutex.synchronize { @players.clear }
    end
  end
end
