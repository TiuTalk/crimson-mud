# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Server
      def initialize(port:)
        @port = port
      end

      def start
        server = TCPServer.new(@port)

        loop do
          Thread.new(server.accept) do |socket|
            handle_connection(socket)
          end
        end
      end

      private

      def handle_connection(socket)
        Client.new(socket).handle
      end
    end
  end
end
