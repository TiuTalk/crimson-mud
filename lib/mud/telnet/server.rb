# frozen_string_literal: true

require 'socket'

module Mud
  module Telnet
    class Server
      attr_reader :host, :port

      def initialize(host: '0.0.0.0', port: 4000)
        @host = host
        @port = port
        @server = nil
      end

      def start
        @server = TCPServer.new(@host, @port)
        Mud.logger.info("Server listening on #{@host}:#{@port}")

        loop do
          Thread.start(@server.accept) do |socket|
            handle_client(socket)
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

      def handle_client(socket)
        Client.new(socket).handle
      end
    end
  end
end
