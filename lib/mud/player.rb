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
  end
end
