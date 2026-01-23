# frozen_string_literal: true

module Mud
  module Commands
    class Base
      class << self
        attr_accessor :usage, :min_args

        def command(*keywords, args: 0, usage: nil)
          self.min_args = args
          self.usage = usage
          Registry.register(*keywords, self)
        end

        def validate(method)
          validations << method
        end

        def validations
          @validations ||= []
        end

        def execute(player, args = '')
          new(player:, args:).execute
        end
      end

      def initialize(player:, args: '')
        @player = player
        @args = args.to_s.split(/\s+/)
      end

      def execute
        Mud.logger.debug("#{player.name} executing: #{self.class.name}")

        return player.puts(self.class.usage) if insufficient_args?

        error = validate
        return player.puts(error) if error

        perform
      end

      def validate
        self.class.validations.each do |method|
          error = send(method)
          return error if error
        end
        nil
      end

      def insufficient_args?
        self.class.min_args&.positive? && @args.size < self.class.min_args && self.class.usage
      end

      private

      attr_reader :player, :args
      alias actor player

      def perform
        raise NotImplementedError, "#{self.class}#perform must be implemented"
      end

      def room = player.room
    end
  end
end
