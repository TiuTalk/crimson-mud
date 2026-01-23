# frozen_string_literal: true

module Mud
  module Actions
    class Tell < Base
      def perform(target:, message:)
        actor.puts("&mYou tell #{target.name}, '#{message}'")
        target.puts("&m#{actor.name} tells you, '#{message}'")
      end
    end
  end
end
