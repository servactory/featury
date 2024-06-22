# frozen_string_literal: true

module Featury
  module Actions
    module Tools
      class Performer
        def self.perform!(...)
          new(...).perform!
        end

        def initialize(context, action, collection_of_features)
          @context = context
          @action = action
          @collection_of_features = collection_of_features
        end

        def perform!
          @action.block.call(features: @collection_of_features.list)
        end
      end
    end
  end
end
