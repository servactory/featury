# frozen_string_literal: true

module Featury
  module MainCondition
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        # def inherited(child)
        #   super
        #
        #   child.send(:collection_of_actions).merge(collection_of_actions)
        # end

        private

        def main_condition(condition)
          # TODO
          condition.call(resources: [])
        end
      end
    end
  end
end
