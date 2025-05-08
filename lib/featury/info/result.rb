# frozen_string_literal: true

module Featury
  module Info
    class Result
      attr_reader :features, :groups, :tree

      def initialize(features:, groups:, tree:)
        @features = features
        @groups = groups
        @tree = tree
      end
    end
  end
end
