# frozen_string_literal: true

module Mud
  class Color
    CODES = {
      'k' => 30, 'r' => 31, 'g' => 32, 'y' => 33,
      'b' => 34, 'm' => 35, 'c' => 36, 'w' => 37,
      'K' => 90, 'R' => 91, 'G' => 92, 'Y' => 93,
      'B' => 94, 'M' => 95, 'C' => 96, 'W' => 97,
      'n' => 0
    }.freeze

    PLACEHOLDER = "\x00"
    RESET = "\e[0m"

    class << self
      def colorize(text)
        return text unless text.include?('&')

        text
          .then { escape_ampersands(_1) }
          .then { replace_codes(_1) }
          .then { restore_ampersands(_1) }
          .then { append_reset_if_needed(_1) }
      end

      def strip(text)
        return text unless text.include?('&')

        text
          .then { escape_ampersands(_1) }
          .then { strip_codes(_1) }
          .then { restore_ampersands(_1) }
      end

      private

      def escape_ampersands(text)
        text.gsub('&&', PLACEHOLDER)
      end

      def replace_codes(text)
        codes = CODES.keys.join
        text.gsub(/(?:&[#{codes}])*&([#{codes}])/) { "\e[#{CODES[Regexp.last_match(1)]}m" }
      end

      def restore_ampersands(text)
        text.gsub(PLACEHOLDER, '&')
      end

      def strip_codes(text)
        text.gsub(/&[#{CODES.keys.join}]/, '')
      end

      def append_reset_if_needed(text)
        text.include?("\e[") ? text + RESET : text
      end
    end
  end
end
