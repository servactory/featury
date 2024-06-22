# frozen_string_literal: true

module Featury
  module Resources
    class Resource
      attr_reader :name, :options

      def initialize(name, **options)
        @name = name
        @options = options
      end
    end
  end
end
