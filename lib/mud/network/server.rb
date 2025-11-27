# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Server
      attr_reader :players

      def initialize(port:)
        @port = port
        @running = false
        @players = Set.new
        @mutex = Mutex.new
      end

      def start
        @running = true
        @server = TCPServer.new('::', @port)
        Mud.logger.info("Server started on port #{@port}")

        Thread.new(@server.accept) { handle_connection(_1) } while @running
      rescue IOError, Errno::EBADF
        # Server closed
      end

      def stop
        return unless @running

        Mud.logger.info('Server stopped')
        @running = false
        @server&.close
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

      def handle_connection(socket)
        client = Client.new(socket:)
        player = welcome(client)
        return unless player

        add_player(player)
        Mud.logger.info("#{player.name} connected (#{player.ip_address})")
        listen(player)
      ensure
        remove_player(player) if player
        Mud.logger.info("#{player&.name || 'Visitor'} disconnected (#{client.ip_address})")
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

      def listen(player)
        while (line = player.gets)
          message = line.chomp
          player.puts("You say, '#{message}'")
          broadcast("#{player.name} says, '#{message}'", except: player)
        end
      end

      def valid_name?(input)
        !input.nil? && !input.empty?
      end
    end
  end
end
