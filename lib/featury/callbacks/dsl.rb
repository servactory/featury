# frozen_string_literal: true

module Featury
  module Callbacks
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_callbacks).merge(collection_of_callbacks)
        end

        private

        def before
          collection_of_callbacks << Callback.new(
            :before,
            block: ->(features:) { yield(features:) }
          )
        end

        def after
          collection_of_callbacks << Callback.new(
            :after,
            block: ->(features:) { yield(features:) }
          )
        end

        def collection_of_callbacks
          @collection_of_callbacks ||= Collection.new
        end
      end
    end
  end
end
