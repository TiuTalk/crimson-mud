# frozen_string_literal: true

module Mud
  module Sanitizer
    ANSI_CSI_PATTERN = /\e\[[0-9;?]*[A-Za-z~]/
    ANSI_OSC_PATTERN = /\e\][^\a]*\a/

    def self.strip_ansi(text)
      return text if text.nil? || text.empty?

      text.gsub(ANSI_CSI_PATTERN, '').gsub(ANSI_OSC_PATTERN, '')
    end
  end
end
