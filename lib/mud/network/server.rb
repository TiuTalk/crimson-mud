# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Server
      def initialize(port:)
        @port = port
        @running = false
      end

      def start
        @running = true
        @server = TCPServer.new(@port)
        Mud.logger.info("Server started on port #{@port}")

        Thread.new(@server.accept) { handle_connection(_1) } while @running
      rescue Errno::EBADF
        # Server closed
      end

      def stop
        return unless @running

        Mud.logger.info('Server stopped')
        @running = false
        @server&.close
      end

      private

      def handle_connection(socket)
        Client.new(socket).handle
      end
    end
  end
end
