# frozen_string_literal: true

module Featury
  module Actions
    module Workspace
      private

      # rubocop:disable Metrics/MethodLength
      def call!(
        action:,
        incoming_arguments:,
        collection_of_resources:,
        collection_of_conditions:,
        collection_of_features:,
        collection_of_groups:,
        **
      )
        puts ":: #{self.class.name} » Actions::Workspace » call!"

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
      # rubocop:enable Metrics/MethodLength
    end
  end
end
