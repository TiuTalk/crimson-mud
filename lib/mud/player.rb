# frozen_string_literal: true

require 'forwardable'

module Mud
  class Player
    extend Forwardable

    attr_reader :name, :client

    def_delegators :client, :gets, :read, :write, :close

    def puts(text)
      client.puts(Color.colorize(text))
    end

    def initialize(name:, client:)
      @name = name
      @client = client
    end

    def quit
      puts "Goodbye, #{name}!"
      close
    end

    def run
      processor = Commands::Processor.new(player: self)

      while (input = gets&.chomp)
        next if input.strip.empty?

        processor.process(input)
      end
    ensure
      close
    end
  end
end
