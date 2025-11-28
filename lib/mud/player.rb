# frozen_string_literal: true

require 'forwardable'

module Mud
  class Player
    extend Forwardable

    attr_reader :name

    def_delegators :@client, :puts, :gets, :ip_address
    def_delegator :@client, :close, :disconnect

    def initialize(name:, client:)
      @name = name
      @client = client
    end

    # TODO: Implement command parsing/handler
    def run
      while (line = gets)
        say(line.chomp)
      end
    end

    # TODO: Move to command class
    def say(message)
      puts("You say, '#{message}'")
      Server.instance.broadcast("#{name} says, '#{message}'", except: self)
    end
  end
end
