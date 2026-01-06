# frozen_string_literal: true

require 'forwardable'

module Mud
  class Player
    extend Forwardable

    attr_reader :name, :room, :client

    def_delegators :client, :gets, :read, :write, :close, :remote_address

    def initialize(name:, room:, client:)
      @name = name
      @room = room
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

        Mud.logger.debug("#{name}: #{input}")
        processor.process(input)
      end
    rescue IOError
      # Socket closed (quit or network drop)
    ensure
      close
    end

    def puts(text, prompt: true)
      client.puts(Color.colorize(text))
      write_prompt if prompt
    end

    private

    def write_prompt
      write("\n#{Color.colorize(prompt)} > ")
    end

    def prompt
      '&R100&rHp &B80&bMn &Y75&ymv'
    end
  end
end
