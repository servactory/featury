# frozen_string_literal: true

module Featury
  module Callbacks
    class Service
      def self.call!(...)
        new(...).call!
      end

      def initialize(action:, callbacks:, features:)
        @action = action
        @callbacks = callbacks
        @features = features
      end

      def call!
        @callbacks.where(expected_action_name: @action).each do |callback|
          callback.block.call(action: @action, features: @features)
        end
      end
    end
  end
end
