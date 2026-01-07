# frozen_string_literal: true

module Mud
  module HasPlayers
    def self.included(base)
      base.prepend(Initializer)
    end

    module Initializer
      def initialize(...)
        @players = Set.new
        @players_mutex = Mutex.new
        super
      end
    end

    def players(except: nil)
      result = @players_mutex.synchronize { @players.dup }
      result.delete(except) if except
      result.to_a
    end

    def add_player(player)
      @players_mutex.synchronize { @players.add(player) }
    end

    def remove_player(player)
      @players_mutex.synchronize { @players.delete(player) }
    end

    def broadcast(message, except: nil)
      players(except:).each { |p| p.puts(message) }
    end
  end
end
