# frozen_string_literal: true

module Mud
  class Room
    attr_reader :name, :description

    def self.starting
      @starting ||= new(name: 'The Void', description: 'A dark, empty space. The beginning of all adventures.')
    end

    def initialize(name:, description:)
      @name = name
      @description = description
    end
  end
end
