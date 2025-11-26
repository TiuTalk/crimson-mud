# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Client
      def initialize(socket)
        @socket = socket
      end

      def handle
        Mud.logger.info("Client [#{ip_address}] connected")
        while (line = @socket.gets)
          @socket.puts(line)
        end
      ensure
        Mud.logger.info("Client [#{ip_address}] disconnected")
        @socket.close
      end

      private

      def ip_address
        @socket.peeraddr[3]
      end
    end
  end
end
