# frozen_string_literal: true

module Mud
  module Commands
    module Registry
      @commands = {}
      @mutex = Mutex.new

      class << self
        def register(keyword, klass)
          @mutex.synchronize { @commands[keyword.to_s] = klass }
        end

        def lookup(keyword)
          @mutex.synchronize { @commands[keyword] }
        end

        def unregister(keyword)
          @mutex.synchronize { @commands.delete(keyword.to_s) }
        end
      end
    end
  end
end
