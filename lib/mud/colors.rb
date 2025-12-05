# frozen_string_literal: true

module Mud
  module Colors
    CODES = {
      'k' => 30, 'r' => 31, 'g' => 32, 'y' => 33,
      'b' => 34, 'm' => 35, 'c' => 36, 'w' => 37,
      'K' => 90, 'R' => 91, 'G' => 92, 'Y' => 93,
      'B' => 94, 'M' => 95, 'C' => 96, 'W' => 97
    }.freeze

    PATTERN = /(?:&([#{CODES.keys.join}]))+/
    RESET = "\e[0m"

    def self.parse(text)
      return text if text.nil? || text.empty?

      # Replace double &&
      text = text.gsub('&&', '&')

      # Skip if no color codes found
      return text unless text.match?(PATTERN)

      result = text.gsub(PATTERN) { "\e[#{CODES[Regexp.last_match(1)]}m" }

      # Insert RESET before trailing newlines, or append if none
      if /(\r?\n)+\z/.match?(result)
        result.sub(/(\r?\n)+\z/, "#{RESET}\\0")
      else
        result + RESET
      end
    end
  end
end
