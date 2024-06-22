# frozen_string_literal: true

module Featury
  module Features
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :merge

      def initialize(collection = Set.new)
        @collection = collection
      end

      def list
        map { |feature| :"#{feature.prefix}_#{feature.name}" }
      end
    end
  end
end
