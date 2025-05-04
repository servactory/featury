# frozen_string_literal: true

module Featury
  module Context
    module Workspace
      private

      attr_reader :action,
                  :incoming_arguments,
                  :collection_of_callbacks,
                  :collection_of_conditions,
                  :collection_of_features,
                  :collection_of_groups

      def _call!(
        action:,
        incoming_arguments:,
        collection_of_callbacks:,
        collection_of_resources:,
        collection_of_conditions:,
        collection_of_features:,
        collection_of_groups:
      )
        call!(
          action:,
          incoming_arguments:,
          collection_of_callbacks:,
          collection_of_resources:,
          collection_of_conditions:,
          collection_of_features:,
          collection_of_groups:
        )
      end

      def call!(
        action:,
        incoming_arguments:,
        collection_of_callbacks:,
        collection_of_resources:,
        collection_of_conditions:,
        collection_of_features:,
        collection_of_groups:
      )
        @action = action
        @incoming_arguments = incoming_arguments
        @collection_of_callbacks = collection_of_callbacks
        @collection_of_resources = collection_of_resources
        @collection_of_conditions = collection_of_conditions
        @collection_of_features = collection_of_features
        @collection_of_groups = collection_of_groups
      end
    end
  end
end
