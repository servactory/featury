# frozen_string_literal: true

module Featury
  module Info
    class Result
      class Actions
        class Web
          attr_reader :all,
                      :enabled,
                      :enable,
                      :disable

          def initialize(collection_of_actions)
            @all = collection_of_actions.names
            @enabled = collection_of_actions.web_enabled&.name
            @enable = collection_of_actions.web_enable&.name
            @disable = collection_of_actions.web_disable&.name
          end
        end

        attr_reader :all,
                    :web

        def initialize(collection_of_actions)
          @all = collection_of_actions.names
          @web = Web.new(collection_of_actions.for_web)
        end
      end

      class Resources
        attr_reader :all

        def initialize(collection_of_resources)
          @all = collection_of_resources
        end
      end

      class Features
        attr_reader :all

        def initialize(collection_of_features)
          @all = collection_of_features
        end
      end

      class Groups
        attr_reader :all

        def initialize(collection_of_groups)
          @all = collection_of_groups
        end
      end

      class Tree
        attr_reader :all

        class Features
          attr_reader :features,
                      :groups

          def initialize(features, groups)
            @features = features.map do |feature|
              Feature.new(
                name: feature.name,
                description: feature.description
              )
            end

            @groups = groups.flat_map do |group|
              group.group_class.info.tree
            end
          end

          class Feature
            attr_reader :name,
                        :description

            def initialize(name:, description:)
              @name = name
              @description = description
            end
          end
        end

        def initialize(features, groups)
          @all = Features.new(features, groups)

          # @groups = groups.flat_map do |group|
          #   group.group_class.info.tree
          # end
        end

        # nested: @groups.flat_map do |group|
        #   group.group_class.info.tree
        # end
      end

      attr_reader :actions,
                  :resources,
                  :features,
                  :groups,
                  :tree

      def initialize(actions:, resources:, features:, groups:, tree:)
        @actions = actions
        @resources = resources
        @features = features
        @groups = groups
        @tree = tree
      end
    end
  end
end
