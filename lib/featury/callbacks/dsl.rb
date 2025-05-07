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

        def before(action = nil)
          collection_of_callbacks << Callback.new(
            :before,
            expected_action_name: action,
            block: ->(**arguments) { yield(**arguments) }
          )
        end

        def after(action = nil)
          collection_of_callbacks << Callback.new(
            :after,
            expected_action_name: action,
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
