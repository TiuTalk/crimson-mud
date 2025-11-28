# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class TelnetServer
      def initialize(port: Mud.configuration.port)
        @port = port
        @running = false
      end

      def start
        @running = true
        @server = TCPServer.new('::', @port)
        Mud.logger.info("Server started on port #{@port}")

        while @running
          socket = @server.accept
          # :nocov:
          Thread.new(socket) { handle_client(_1) }
          # :nocov:
        end
      rescue IOError, Errno::EBADF
        # Server closed
      end

      def stop
        return unless @running

        Mud.logger.info('Server stopped')
        @running = false
        @server&.close
      end

      def handle_client(socket)
        Mud::Server.instance.handle_connection(socket)
      end
    end
  end
end
