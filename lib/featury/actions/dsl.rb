# frozen_string_literal: true

module Featury
  module Actions
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_actions).merge(collection_of_actions)
        end

        private

        def action(name)
          collection_of_actions << Action.new(
            name,
            block: ->(features:, **options) { yield(features: features, **options) }
          )
        end

        def collection_of_actions
          @collection_of_actions ||= Collection.new
        end
      end
    end
  end
end
