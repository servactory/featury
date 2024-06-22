# frozen_string_literal: true

module Featury
  module Actions
    module Workspace
      private

      def call!(
        action:,
        incoming_arguments:,
        collection_of_resources:,
        collection_of_conditions:,
        collection_of_features:,
        collection_of_groups:,
        **
      )
        service_result = Service::Builder.build_and_call!(
          context: self,
          action: action,
          incoming_arguments: incoming_arguments,
          collection_of_resources: collection_of_resources,
          collection_of_conditions: collection_of_conditions,
          collection_of_features: collection_of_features,
          collection_of_groups: collection_of_groups
        )

        super && service_result.success? && service_result.all_true?
      end
    end
  end
end
