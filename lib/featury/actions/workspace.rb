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
        puts ":: #{self.class.name} » Actions::Workspace » call!"

        super &&
          Service::ServiceBuilder.build_and_call!(
            self,
            action,
            incoming_arguments,
            collection_of_resources,
            collection_of_conditions,
            collection_of_features,
            collection_of_groups
          ).result
      end
    end
  end
end
