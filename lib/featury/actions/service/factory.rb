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

        def create_service_class # rubocop:disable Metrics/MethodLength, Metrics/AbcSize,Metrics/CyclomaticComplexity
          collection_of_resources = @collection_of_resources

          Class.new(Featury::Service::Builder) do
            collection_of_resources.each do |resource|
              input resource.name, required: resource.required?, **resource.options
            end

            input :action, type: Featury::Actions::Action

            input :collection_of_resources,
                  type: Featury::Resources::Collection,
                  required: false,
                  default: Featury::Resources::Collection.new

            input :collection_of_conditions,
                  type: Featury::Conditions::Collection,
                  required: false,
                  default: Featury::Conditions::Collection.new

            input :collection_of_features,
                  type: Featury::Features::Collection,
                  required: false,
                  default: Featury::Features::Collection.new

            input :collection_of_groups,
                  type: Featury::Groups::Collection,
                  required: false,
                  default: Featury::Groups::Collection.new

            output :all_true, type: [TrueClass, FalseClass]

            check :all

            private

            def check_all
              outputs.all_true = conditions_are_true
              return unless outputs.all_true

              outputs.all_true = features_are_true
              return unless outputs.all_true

              outputs.all_true = groups_are_true
            end

            ####################################################################

            def conditions_are_true
              inputs.collection_of_conditions.all? do |condition|
                condition.block.call(resources: inputs)
              end
            end

            def features_are_true
              options = inputs.collection_of_resources.only_option.to_h do |resource|
                [resource.name, inputs.public_send(resource.name)]
              end.compact

              inputs.action.block.call(features: inputs.collection_of_features.names, **options)
            end

            def groups_are_true # rubocop:disable Metrics/AbcSize
              arguments = inputs.collection_of_resources.only_nested.to_h do |resource|
                [resource.name, inputs.public_send(resource.name)]
              end.compact

              inputs.collection_of_groups.all? do |group|
                group.group_class.public_send(inputs.action.name, **arguments)
              end
            end
          end
        end
      end
    end
  end
end
