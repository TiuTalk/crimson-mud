# frozen_string_literal: true

require 'singleton'
require 'socket'

module Mud
  module Telnet
    class Server
      include Singleton

      attr_reader :players

      def initialize
        @server = nil
        @players = []
        @players_mutex = Mutex.new
      end

      def add_player(player)
        @players_mutex.synchronize { @players << player }
      end

      def remove_player(player)
        @players_mutex.synchronize { @players.delete(player) }
      end

      def clear_players
        @players_mutex.synchronize { @players.clear }
      end

      def broadcast(message, except: nil)
        players = @players_mutex.synchronize { @players.dup }
        players.each do |player|
          next if player == except

          player.puts(message)
        end
      end

      def start
        @server = TCPServer.new(host, port)
        Mud.logger.info("Server listening on #{host}:#{port}")

        loop do
          Thread.start(@server.accept) do |socket|
            handle_client(socket:)
          end
        end
      rescue Interrupt, IOError
        # Do nothing
      ensure
        stop
      end

      def stop
        return unless @server && !@server.closed?

        Mud.logger.info('Server stopped')
        @server.close
      end

      def handle_client(socket:)
        client = Client.new(socket:)
        log_connect(client)
        client.puts('Welcome to Crimson MUD!')
        client.puts('What is your name?')
        name = client.gets&.chomp
        return if name.nil? || name.empty?

        client.puts("Welcome, #{name}!")
        player = Player.new(name:, client:)
        add_player(player)
        player.run
      ensure
        remove_player(player) if player
        log_disconnect(client)
      end

      private

      def host = Mud.configuration.host
      def port = Mud.configuration.port

      def log_connect(client)
        Mud.logger.info("Connected: #{client.remote_address}")
      end

      def log_disconnect(client)
        Mud.logger.info("Disconnected: #{client.remote_address}")
      end
    end
  end
end
