# frozen_string_literal: true

module Featury
  module Callbacks
    class Callback
      attr_reader :expected_actions, :block

      def initialize(stage, expected_actions:, block:)
        @stage = stage.to_sym
        @expected_actions = expected_actions
        @block = block
      end

      def before?
        @stage == :before
      end

      def after?
        @stage == :after
      end
    end
  end
end
