# frozen_string_literal: true

module Featury
  module Actions
    module Service
      class ServiceBuilder
        SERVICE_CLASS_NAME = "SBuilder"

        def self.build_and_call!(...)
          new(...).build_and_call!
        end

        def initialize(
          context,
          action,
          incoming_arguments,
          collection_of_resources,
          collection_of_conditions,
          collection_of_features,
          collection_of_groups
        )
          @context = context
          @action = action
          @incoming_arguments = incoming_arguments
          @collection_of_resources = collection_of_resources
          @collection_of_conditions = collection_of_conditions
          @collection_of_features = collection_of_features
          @collection_of_groups = collection_of_groups
        end

        def build_and_call!
          ServiceFactory.create(@context.class, @collection_of_resources)

          builder_class.call!(
            action: @action,
            **@incoming_arguments,
            collection_of_conditions: @collection_of_conditions,
            collection_of_features: @collection_of_features,
            collection_of_groups: @collection_of_groups
          )
        end

        private

        def builder_class
          "#{@context.class.name}::#{SERVICE_CLASS_NAME}".constantize
        end
      end
    end
  end
end
