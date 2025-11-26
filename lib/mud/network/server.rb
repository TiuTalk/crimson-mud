# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Server
      attr_reader :clients

      def initialize(port:)
        @port = port
        @running = false
        @clients = Set.new
        @mutex = Mutex.new
      end

      def start
        @running = true
        @server = TCPServer.new('::', @port)
        Mud.logger.info("Server started on port #{@port}")

        Thread.new(@server.accept) { handle_connection(_1) } while @running
      rescue IOError, Errno::EBADF
        # Server closed
      end

      def stop
        return unless @running

        Mud.logger.info('Server stopped')
        @running = false
        @server&.close
      end

      def add_client(client)
        @mutex.synchronize { @clients.add(client) }
      end

      def remove_client(client)
        @mutex.synchronize { @clients.delete(client) }
      end

      def broadcast(message, except: nil)
        @mutex.synchronize { @clients.to_a }.each { _1.puts(message) unless _1 == except }
      end

      private

      def handle_connection(socket)
        Client.new(socket:, server: self).handle
      end
    end
  end
end
