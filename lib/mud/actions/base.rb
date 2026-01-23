# frozen_string_literal: true

module Mud
  module Actions
    class Base
      def self.execute(actor:, **args)
        new(actor:).perform(**args)
      end

      def initialize(actor:)
        @actor = actor
      end

      private

      attr_reader :actor

      def room = actor.room
    end
  end
end
