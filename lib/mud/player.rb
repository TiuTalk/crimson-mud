# frozen_string_literal: true

require 'forwardable'

module Mud
  class Player
    extend Forwardable

    attr_reader :name

    def_delegators :@client, :puts, :gets, :ip_address

    def initialize(name:, client:)
      @name = name
      @client = client
    end

    def run
      while (line = gets)
        input = line.chomp.strip
        next if input.empty?

        CommandRegistry.execute(input, player: self)
      end
    end

    def quit
      puts('Goodbye!')
      @client.close
    end
  end
end
