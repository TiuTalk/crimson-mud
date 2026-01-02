# frozen_string_literal: true

require 'abbrev'

module Mud
  module Commands
    module Registry
      @commands = {}
      @abbreviations = {}

      class << self
        def register(*keywords, klass)
          keywords.each { @commands[normalize_keyword(_1)] = klass }
          build_abbreviations
        end

        def lookup(keyword)
          @commands[@abbreviations[normalize_keyword(keyword)]]
        end

        def unregister(*keywords)
          keywords.each { @commands.delete(normalize_keyword(_1)) }
          build_abbreviations
        end

        def keywords
          @commands.keys.sort
        end

        private

        def normalize_keyword(keyword) = keyword.to_s.downcase.to_sym

        def build_abbreviations
          @abbreviations = @commands.keys.map(&:to_s).abbrev.to_h { |k, v| [k.to_sym, v.to_sym] }
        end
      end
    end
  end
end
