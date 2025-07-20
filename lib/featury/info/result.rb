# frozen_string_literal: true

module Featury
  module Info
    class Result
      attr_reader :actions,
                  :features,
                  :groups,
                  :tree

      def initialize(actions:, features:, groups:, tree:)
        @actions = actions
        @features = features
        @groups = groups
        @tree = tree
      end
    end
  end
end
