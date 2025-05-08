# frozen_string_literal: true

module Featury
  module Info
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def info
          Featury::Info::Result.new(
            features: collection_of_features.map(&:full_name),
            groups: collection_of_groups.map(&:group)
          )
        end
      end
    end
  end
end
