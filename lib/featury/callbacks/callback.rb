# frozen_string_literal: true

module Featury
  module Callbacks
    class Callback
      attr_reader :expected_action_name, :block

      def initialize(stage, expected_action_name:, block:)
        @stage = stage.to_sym
        @expected_action_name = expected_action_name
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
