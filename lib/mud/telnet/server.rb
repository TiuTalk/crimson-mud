# frozen_string_literal: true

require 'singleton'
require 'socket'

module Mud
  module Telnet
    class Server
      include Singleton

      def initialize
        @server = nil
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
        name = prompt_for_name(client)
        return if name.nil? || name.empty?

        player = Player.new(name:, room: Room.starting, client:)
        run_player(player)
      ensure
        Mud.world.remove_player(player) if player
        log_disconnect(client, player)
      end

      private

      def host = Mud.configuration.host
      def port = Mud.configuration.port

      def prompt_for_name(client)
        client.puts('Welcome to Crimson MUD!')
        client.puts('What is your name?')
        client.gets&.chomp
      end

      def run_player(player)
        log_connect(player)
        Mud.world.add_player(player)
        player.puts("Welcome, #{player.name}!")
        player.run
      end

      def log_connect(player)
        Mud.logger.info("Connected: #{player.name} (#{player.remote_address})")
      end

      def log_disconnect(client, player)
        identifier = player ? "#{player.name} (#{client.remote_address})" : client.remote_address
        Mud.logger.info("Disconnected: #{identifier}")
      end
    end
  end
end
