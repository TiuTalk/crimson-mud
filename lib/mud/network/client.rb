# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Client
      def initialize(socket:, server:)
        @socket = socket
        @server = server
      end

      def handle
        @server.add_client(self)
        Mud.logger.info("Client [#{ip_address}] connected")
        while (line = @socket.gets)
          @server.broadcast("[#{ip_address}] #{line.chomp}")
        end
      ensure
        @server.remove_client(self)
        Mud.logger.info("Client [#{ip_address}] disconnected")
        @socket.close
      end

      def puts(message)
        @socket.puts(message)
      end

      private

      def ip_address
        @socket.peeraddr[3]
      end
    end
  end
end
