# frozen_string_literal: true

module Featury
  module Callbacks
    class Callback
      attr_reader :desired_actions, :block

      def initialize(stage:, desired_actions:, block:)
        @stage = stage.to_sym
        @desired_actions = desired_actions
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
