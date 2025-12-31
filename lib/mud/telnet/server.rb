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
        Player.new(client:).run
      ensure
        log_disconnect(client)
      end

      private

      def log_connect(client)
        Mud.logger.info("Connected: #{client.remote_address}")
      end

      def log_disconnect(client)
        Mud.logger.info("Disconnected: #{client.remote_address}")
      end
    end
  end
end
