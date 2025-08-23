# frozen_string_literal: true

module Featury
  module Features
    class Collection
      extend Forwardable

      def_delegators :@collection, :<<, :each, :map, :merge, :to_a, :empty?

      def initialize(collection = Set.new)
        @collection = collection
      end

      def names
        map(&:name)
      end
    end
  end
end
