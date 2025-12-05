# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Client
      def initialize(socket:)
        @socket = socket
      end

      def puts(message)
        @socket.puts(message)
      rescue IOError, Errno::EPIPE
        # Client disconnected, ignore
      end

      def write(message)
        @socket.write(message)
      rescue IOError, Errno::EPIPE
        # Client disconnected, ignore
      end

      def gets
        @socket.gets
      rescue IOError, Errno::EPIPE
        nil
      end

      def close
        @socket.close
      rescue IOError, Errno::EBADF
        # Socket already closed, ignore
      end

      def ip_address
        @socket.remote_address.ip_address
      rescue IOError, Errno::EBADF
        'unknown'
      end
    end
  end
end
