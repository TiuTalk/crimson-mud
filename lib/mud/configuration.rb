# frozen_string_literal: true

module Mud
  class Configuration
    attr_accessor :logger, :port

    def initialize
      @logger = Logger.new($stdout)
      @port = ENV.fetch('PORT', 4000).to_i
    end
  end
end
