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
