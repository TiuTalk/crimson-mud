# frozen_string_literal: true

require 'logger'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup
loader.eager_load_dir("#{__dir__}/mud/commands")

module Mud
  class Error < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def logger
      configuration.logger
    end
  end
end
