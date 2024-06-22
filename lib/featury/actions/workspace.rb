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
        **
      )
        puts ":: Actions::Workspace » call!"

        super &&
          Featury::Actions::Tools::Performer.perform!(self, action, collection_of_features) &&
          Service::ServiceBuilder.build_and_call!(
            self,
            action,
            incoming_arguments,
            collection_of_resources,
            collection_of_conditions,
            collection_of_features
          ).result
      end
    end
  end
end
