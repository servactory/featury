# frozen_string_literal: true

module Featury
  module Context
    module Workspace
      private

      attr_reader :action,
                  :collection_of_conditions,
                  :collection_of_features

      def _call!(action:, collection_of_conditions:, collection_of_features:)
        call!(action: action, collection_of_conditions:, collection_of_features:)
      end

      def call!(action:, collection_of_conditions:, collection_of_features:)
        @action = action
        @collection_of_conditions = collection_of_conditions
        @collection_of_features = collection_of_features
      end
    end
  end
end
