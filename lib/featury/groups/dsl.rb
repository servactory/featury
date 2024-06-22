# frozen_string_literal: true

module Featury
  module Groups
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_groups).merge(collection_of_groups)
        end

        private

        def groups(*groups)
          groups.each do |group|
            collection_of_groups << Group.new(group)
          end
        end

        def collection_of_groups
          @collection_of_groups ||= Collection.new
        end
      end
    end
  end
end
