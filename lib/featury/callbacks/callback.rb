# frozen_string_literal: true

module Featury
  module Callbacks
    class Callback
      attr_reader :block

      def initialize(stage, block:)
        @stage = stage.to_sym
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
