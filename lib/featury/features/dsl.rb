# frozen_string_literal: true

module Featury
  module Features
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_features).merge(collection_of_features)
        end

        private

        def prefix(prefix)
          self.feature_prefix = prefix
        end

        def features(*names)
          names.each do |name|
            collection_of_features << Feature.new(feature_prefix, name)
          end
        end

        def feature_prefix=(value)
          @feature_prefix = value
        end

        def feature_prefix
          @feature_prefix || default_feature_prefix
        end

        def default_feature_prefix
          @default_feature_prefix ||=
            name.underscore
                .gsub(/([a-z])(\d+)/, '\1_\2')
                .gsub(/(\d+)([a-z])/, '\1_\2')
                .tr("/", "_")
                .sub("_feature", "")
                .to_sym
        end

        def collection_of_features
          @collection_of_features ||= Collection.new
        end
      end
    end
  end
end
