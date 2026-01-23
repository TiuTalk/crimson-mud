# frozen_string_literal: true

module Mud
  module Commands
    class Say < Base
      command :say

      validate :requires_message

      def perform
        Actions::Say.execute(actor:, message:)
      end

      private

      def message = Color.strip(args.join(' '))

      def requires_message
        'What do you want to say?' if args.empty?
      end
    end
  end
end
