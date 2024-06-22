# frozen_string_literal: true

module Featury
  module Actions
    module Service
      class Factory
        def self.create(...)
          new(...).create
        end

        def initialize(model_class, collection_of_resources)
          @model_class = model_class
          @collection_of_resources = collection_of_resources
        end

        def create
          return if @model_class.const_defined?(Builder::SERVICE_CLASS_NAME)

          class_sample = create_service_class

          @model_class.const_set(Builder::SERVICE_CLASS_NAME, class_sample)
        end

        def create_service_class # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          collection_of_resources = @collection_of_resources

          Class.new(Featury::Service::Builder) do
            collection_of_resources.each do |resource|
              input resource.name, **resource.options
            end

            input :action, type: Featury::Actions::Action

            input :collection_of_conditions, type: Featury::Conditions::Collection
            input :collection_of_features, type: Featury::Features::Collection
            input :collection_of_groups, type: Featury::Groups::Collection

            internal :conditions_are_true, type: [TrueClass, FalseClass]
            internal :features_are_true, type: [TrueClass, FalseClass]
            internal :groups_are_true, type: [TrueClass, FalseClass]

            output :all_true, type: [TrueClass, FalseClass]

            check :conditions
            check :features
            check :groups

            check :all

            private

            def check_conditions
              internals.conditions_are_true = inputs.collection_of_conditions.all? do |condition|
                condition.block.call(resources: inputs)
              end
            end

            def check_features
              internals.features_are_true = inputs.action.block.call(features: inputs.collection_of_features.list)
            end

            def check_groups
              arguments = inputs.instance_variable_get(:@collection_of_inputs).names.to_h do |input_name|
                [input_name, inputs.public_send(input_name)]
              end

              internals.groups_are_true = inputs.collection_of_groups.all? do |group|
                group.group.public_send(inputs.action.name, **arguments)
              end
            end

            def check_all
              outputs.all_true =
                internals.conditions_are_true &&
                internals.features_are_true &&
                internals.groups_are_true
            end
          end
        end
      end
    end
  end
end
