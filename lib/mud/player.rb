# frozen_string_literal: true

require 'forwardable'

module Mud
  class Player
    extend Forwardable

    attr_reader :name

    def_delegators :@client, :gets, :ip_address

    def initialize(name:, client:)
      @name = name
      @client = client
    end

    def puts(message, prompt: true)
      @client.puts(message)
      @client.write(self.prompt) if prompt
    end

    def run
      while (line = gets)
        input = line.chomp.strip
        next if input.empty?

        Mud.logger.debug("#{name} input #{input.inspect}")
        CommandRegistry.execute(input, player: self)
      end
    end

    def quit
      puts('Goodbye!', prompt: false)
      @client.close
    end

    private

    def prompt
      "\n&R100&rhp &B50&bmn &Y25&ymv&n > #{Network::Telnet::PROMPT_MARKER}"
    end
  end
end
