# frozen_string_literal: true

module Featury
  module Info
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def info
          Featury::Info::Result.new(
            actions: Featury::Info::Result::Actions.new(collection_of_actions),
            resources: Featury::Info::Result::Resources.new(collection_of_resources).all.names,
            features: Featury::Info::Result::Features.new(collection_of_features).all,
            groups: Featury::Info::Result::Groups.new(collection_of_groups).all,
            tree: Featury::Info::Result::Tree.new(collection_of_features, collection_of_groups).all
          )
        end

        # API: Featury Web
        def featury?
          true
        end
      end
    end
  end
end
