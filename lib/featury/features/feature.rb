# frozen_string_literal: true

module Featury
  module Features
    class Feature
      attr_reader :prefix, :name

      def initialize(prefix, name)
        @prefix = prefix
        @name = name
      end
    end
  end
end
