# frozen_string_literal: true

module Featury
  module Callbacks
    class Service
      def self.call!(...)
        new(...).call!
      end

      def initialize(collection_of_callbacks:, collection_of_features:)
        @collection_of_callbacks = collection_of_callbacks
        @collection_of_features = collection_of_features
      end

      def call!
        @collection_of_callbacks.each do |callback|
          callback.block.call(features: @collection_of_features)
        end
      end
    end
  end
end
