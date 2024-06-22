# frozen_string_literal: true

module Featury
  module Conditions
    class Condition
      attr_reader :block

      def initialize(block)
        @block = block
      end
    end
  end
end
