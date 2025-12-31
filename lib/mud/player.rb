# frozen_string_literal: true

require 'forwardable'

module Mud
  class Player
    extend Forwardable

    attr_reader :client

    def_delegators :client, :gets, :puts, :read, :write, :close

    def initialize(client)
      @client = client
    end

    def run
      while (input = gets&.chomp)
        break if input == 'quit'

        puts(input)
      end
    ensure
      close
    end
  end
end
