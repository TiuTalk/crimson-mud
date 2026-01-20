# frozen_string_literal: true

module Mud
  module Commands
    class Commands < Base
      command :commands

      def perform
        keywords = Registry.keywords
        col_width = keywords.map(&:length).max + 5
        lines = keywords.each_slice(4).map { |row| row.map { _1.to_s.ljust(col_width) }.join.rstrip }

        player.puts(<<~OUTPUT.chomp)
          Available commands:
          #{lines.join("\n")}
        OUTPUT
      end
    end
  end
end
