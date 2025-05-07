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

        def before(*actions)
          collection_of_callbacks << Callback.new(
            :before,
            desired_actions: actions,
            block: ->(**arguments) { yield(**arguments) }
          )
        end

        def after(*actions)
          collection_of_callbacks << Callback.new(
            :after,
            desired_actions: actions,
            block: ->(**arguments) { yield(**arguments) }
          )
        end

        def collection_of_callbacks
          @collection_of_callbacks ||= Collection.new
        end
      end
    end
  end
end
