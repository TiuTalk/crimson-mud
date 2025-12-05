# frozen_string_literal: true

module Mud
  module Network
    module Telnet
      IAC = "\xFF"
      GA  = "\xF9"
      EOR = "\xEF"
      PROMPT_MARKER = "#{IAC}#{GA}#{IAC}#{EOR}".freeze
    end
  end
end
