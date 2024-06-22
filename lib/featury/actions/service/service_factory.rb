# frozen_string_literal: true

module Featury
  module Actions
    module Service
      class ServiceFactory
        def self.create(...)
          new(...).create
        end

        def initialize(model_class, collection_of_resources)
          @model_class = model_class
          @collection_of_resources = collection_of_resources
        end

        def create
          return if @model_class.const_defined?(ServiceBuilder::SERVICE_CLASS_NAME)

          class_sample = create_service_class

          @model_class.const_set(ServiceBuilder::SERVICE_CLASS_NAME, class_sample)
        end

        def create_service_class
          collection_of_resources = @collection_of_resources

          Class.new(Featury::Service::Builder) do
            collection_of_resources.each do |resource|
              input resource.name, **resource.options
            end

            input :action, type: Featury::Actions::Action

            input :collection_of_conditions, type: Featury::Conditions::Collection
            input :collection_of_features, type: Featury::Features::Collection
            input :collection_of_groups, type: Featury::Groups::Collection

            internal :conditions, type: [TrueClass, FalseClass]
            internal :features, type: [TrueClass, FalseClass]
            internal :groups, type: [TrueClass, FalseClass]

            output :result, type: [TrueClass, FalseClass]

            make :conditions
            make :features
            make :groups

            make :result

            private

            def conditions
              internals.conditions = inputs.collection_of_conditions.all? do |condition|
                condition.block.call(resources: inputs)
              end
            end

            def features
              internals.features = inputs.action.block.call(features: inputs.collection_of_features.list)
            end

            def groups
              arguments = inputs.instance_variable_get(:@collection_of_inputs).names.to_h do |input_name|
                [input_name, inputs.public_send(input_name)]
              end

              internals.groups = inputs.collection_of_groups.all? do |group|
                group.group.public_send(inputs.action.name, **arguments)
              end
            end

            def result
              # puts
              # puts internals.features.inspect
              # puts

              outputs.result = internals.conditions && internals.features
            end
          end
        end
      end
    end
  end
end
