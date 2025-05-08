# frozen_string_literal: true

module Featury
  module Info
    class Result
      attr_reader :features, :groups

      def initialize(features:, groups:)
        @features = features
        @groups = groups
      end
    end
  end
end
