# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/mud/concerns")
loader.setup
loader.eager_load_dir("#{__dir__}/mud/commands")

module Mud
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.logger = configuration.logger
  def self.server = Telnet::Server.instance
  def self.world = World.instance
end
