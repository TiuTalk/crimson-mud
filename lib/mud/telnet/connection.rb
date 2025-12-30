# frozen_string_literal: true

module Mud
  module Telnet
    class Connection
      def initialize(socket)
        @socket = socket
        @remote_address = socket.remote_address
      end

      def handle
        Mud.logger.info("Client connected: #{remote_address}")

        while (input = @socket.gets&.chomp)
          break if input == 'quit'

          @socket.puts(input)
        end
      rescue StandardError => e
        Mud.logger.error(e.inspect)
      ensure
        Mud.logger.info("Client disconnected: #{remote_address}")
        @socket.close unless @socket.closed?
      end

      private

      def remote_address
        "#{@remote_address.ip_address}:#{@remote_address.ip_port}"
      end
    end
  end
end
