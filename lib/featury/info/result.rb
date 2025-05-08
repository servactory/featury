# frozen_string_literal: true

module Featury
  module Info
    class Result
      attr_reader :features

      def initialize(features:)
        @features = features
      end
    end
  end
end
