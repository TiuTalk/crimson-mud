# frozen_string_literal: true

require 'singleton'

module Mud
  class Server
    include Singleton

    attr_reader :players

    def initialize
      @players = Set.new
      @mutex = Mutex.new
    end

    def handle_connection(socket)
      client = Network::Client.new(socket:)
      player = welcome(client)
      return unless player

      add_player(player)
      Mud.logger.info("#{player.name} connected (#{player.ip_address})")
      broadcast("#{player.name} arrived.", except: player)
      player.run
    ensure
      disconnect(player, client)
    end

    def add_player(player)
      @mutex.synchronize { @players.add(player) }
    end

    def remove_player(player)
      @mutex.synchronize { @players.delete(player) }
    end

    def broadcast(message, except: nil)
      @mutex.synchronize { @players.dup }.each { _1.puts(message) unless _1 == except }
    end

    private

    def disconnect(player, client)
      remove_player(player) if player
      broadcast("#{player.name} left.") if player
      Mud.logger.info("#{player&.name || 'Visitor'} disconnected")
      client.close
    end

    def welcome(client)
      client.puts('Welcome to Crimson MUD!')

      loop do
        client.puts('What is your name?')
        input = client.gets&.strip

        return nil if input.nil?
        return Player.new(name: input, client:) if valid_name?(input)
      end
    end

    def valid_name?(input)
      !input.nil? && !input.empty?
    end
  end
end
