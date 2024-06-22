# frozen_string_literal: true

module Featury
  module Resources
    class Resource
      attr_reader :name, :options

      def initialize(name, **options)
        @name = name

        @nested = options.delete(:nested) || false
        @option = options.delete(:option) || false

        @options = options
      end

      def nested?
        @nested
      end

      def option?
        @option
      end
    end
  end
end
