# frozen_string_literal: true

module Featury
  module Callbacks
    class Service
      def self.call!(...)
        new(...).call!
      end

      def initialize(callbacks:, features:)
        @callbacks = callbacks
        @features = features
      end

      def call!
        @callbacks.each do |callback|
          callback.block.call(features: @features)
        end
      end
    end
  end
end
