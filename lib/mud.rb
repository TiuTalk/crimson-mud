# frozen_string_literal: true

require 'logger'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module Mud
  class Error < StandardError; end

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout)
    end
  end
end
