# frozen_string_literal: true

require 'logger'

module Mud
  class Configuration
    attr_accessor :logger

    def initialize
      @logger = Logger.new($stdout)
    end
  end
end
