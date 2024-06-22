# frozen_string_literal: true

module Featury
  module Features
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_features).merge(collection_of_features)
        end

        private

        def prefix(prefix)
          @prefix = prefix
        end

        def features(*names)
          names.each do |name|
            collection_of_features << Feature.new(@prefix, name)
          end
        end

        def collection_of_features
          @collection_of_features ||= Collection.new
        end
      end
    end
  end
end
