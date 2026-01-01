# frozen_string_literal: true

require 'logger'

module Mud
  class Configuration
    attr_accessor :host, :port, :logger

    def initialize
      @host = '0.0.0.0'
      @port = 4000
      @logger = Logger.new($stdout)
    end
  end
end
