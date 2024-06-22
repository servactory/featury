# frozen_string_literal: true

module Featury
  module Actions
    class Action
      attr_reader :name, :block

      def initialize(name, block)
        @name = name
        @block = block
      end
    end
  end
end
