# frozen_string_literal: true

module Featury
  module Conditions
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_conditions).merge(collection_of_conditions)
        end

        private

        def condition(condition)
          collection_of_conditions << Condition.new(condition)
        end

        def collection_of_conditions
          @collection_of_conditions ||= Collection.new
        end
      end
    end
  end
end
