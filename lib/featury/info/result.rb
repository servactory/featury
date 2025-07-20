# frozen_string_literal: true

module Featury
  module Info
    class Result
      class Actions
        class Web
          attr_reader :all,
                      :condition,
                      :action

          def initialize(collection_of_actions)
            @all = collection_of_actions.names
            @condition = collection_of_actions.condition_web.name
            @action = collection_of_actions.action_web.name
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
                  :features,
                  :groups,
                  :tree

      def initialize(actions:, features:, groups:, tree:)
        @actions = actions
        @features = features
        @groups = groups
        @tree = tree
      end
    end
  end
end
