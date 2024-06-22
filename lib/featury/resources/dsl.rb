# frozen_string_literal: true

module Featury
  module Resources
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_resources).merge(collection_of_resources)
        end

        private

        def resource(name, **options)
          collection_of_resources << Resource.new(name, **options)
        end

        def collection_of_resources
          @collection_of_resources ||= Collection.new
        end
      end
    end
  end
end
