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
            features: collection_of_features.full_names,
            groups: collection_of_groups.map(&:group),
            tree: collection_of_features.full_names.concat(
              collection_of_groups.map do |group|
                group.group.info.tree
              end
            )
          )
        end

        # API: Featury Web
        def featury?
          true
        end
      end
    end
  end
end
