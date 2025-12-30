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
          Thread.start(@server.accept) do |client|
            handle_client(client)
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

      private

      def handle_client(client)
        Mud.logger.info("Client connected: #{client.inspect}")

        client.puts 'Hello !'
        client.puts "Time is #{Time.now}"
      rescue StandardError => e
        Mud.logger.error(e.inspect)
      ensure
        Mud.logger.info("Client disconnected: #{client.inspect}")
        client.close
      end
    end
  end
end
