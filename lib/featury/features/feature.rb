# frozen_string_literal: true

module Featury
  module Features
    class Feature
      attr_reader :name,
                  :description

      def initialize(prefix:, name:, description:)
        @name = :"#{prefix}_#{name}"
        @description = description
      end
    end
  end
end
