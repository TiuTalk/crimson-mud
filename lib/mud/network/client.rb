# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Client
      attr_reader :name

      def initialize(socket:, server:)
        @socket = socket
        @server = server
        @name = 'Visitor'
      end

      def handle
        @server.add_client(self)
        welcome
        Mud.logger.info("#{@name} connected (#{ip_address})")
        listen
      ensure
        @server.remove_client(self)
        Mud.logger.info("#{@name} disconnected (#{ip_address})")
        @socket.close
      end

      def puts(message)
        @socket.puts(message)
      rescue IOError, Errno::EPIPE
        # Client disconnected, ignore
      end

      private

      def welcome
        @socket.puts('Welcome to Crimson MUD!')

        loop do
          @socket.puts('What is your name?')
          input = @socket.gets&.strip

          return if input.nil? # Stop if client disconnects
          next unless valid_name?(input) # Retry on invalid name

          @name = input
          break
        end
      end

      def listen
        while (line = @socket.gets)
          message = line.chomp
          @socket.puts("You say, '#{message}'")
          @server.broadcast("#{@name} says, '#{message}'", except: self)
        end
      end

      def valid_name?(input)
        !input.nil? && !input.empty?
      end

      def ip_address
        @socket.remote_address.ip_address
      end
    end
  end
end
