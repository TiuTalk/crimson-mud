# frozen_string_literal: true

require 'socket'

module Mud
  module Network
    class Client
      def initialize(socket)
        @socket = socket
      end

      def handle
        while (line = @socket.gets)
          @socket.puts(line)
        end
      ensure
        @socket.close
      end
    end
  end
end
