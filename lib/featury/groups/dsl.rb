# frozen_string_literal: true

module Featury
  module Groups
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_groups).merge(collection_of_groups)
        end

        private

        # DEPRECATED: Need to use the `group` method instead of `groups`.
        def groups(*groups)
          Kernel.warn "DEPRECATION WARNING: " \
                      "Method `groups` is deprecated; " \
                      "use `group` instead. " \
                      "It will be removed in one of the next releases."

          groups.each do |group|
            collection_of_groups << Group.new(group:, description: nil)
          end
        end

        def group(group, description: nil)
          collection_of_groups << Group.new(group:, description:)
        end

        def collection_of_groups
          @collection_of_groups ||= Collection.new
        end
      end
    end
  end
end
