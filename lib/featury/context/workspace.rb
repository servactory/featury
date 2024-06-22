# frozen_string_literal: true

module Featury
  module Context
    module Workspace
      private

      attr_reader :action,
                  :incoming_arguments,
                  :collection_of_conditions,
                  :collection_of_features

      def _call!(action:, incoming_arguments:, collection_of_resources:, collection_of_conditions:, collection_of_features:)
        call!(
          action:,
          incoming_arguments:,
          collection_of_resources:,
          collection_of_conditions:,
          collection_of_features:
        )
      end

      def call!(action:, incoming_arguments:, collection_of_resources:, collection_of_conditions:, collection_of_features:)
        @action = action
        @incoming_arguments = incoming_arguments
        @collection_of_resources = collection_of_resources
        @collection_of_conditions = collection_of_conditions
        @collection_of_features = collection_of_features
      end
    end
  end
end
