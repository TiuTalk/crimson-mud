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

      def gets
        @socket.gets
      rescue IOError, Errno::EPIPE
        nil
      end

      private

      def welcome
        puts('Welcome to Crimson MUD!')

        loop do
          puts('What is your name?')
          input = gets&.strip

          return if input.nil? # Stop if client disconnects
          next unless valid_name?(input) # Retry on invalid name

          @name = input
          break
        end
      end

      def listen
        while (line = gets)
          message = line.chomp
          puts("You say, '#{message}'")
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
