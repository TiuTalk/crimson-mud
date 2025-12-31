# frozen_string_literal: true

require 'forwardable'

module Mud
  module Telnet
    class Client
      extend Forwardable

      def_delegators :@socket, :gets, :puts, :read, :write, :closed?

      def initialize(socket:)
        @socket = socket
        @remote_address = socket.remote_address
      end

      def close
        @socket.close unless closed?
      end

      def remote_address
        "#{@remote_address.ip_address}:#{@remote_address.ip_port}"
      end
    end
  end
end
