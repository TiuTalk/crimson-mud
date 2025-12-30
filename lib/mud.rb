# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module Mud
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.logger = configuration.logger
end
