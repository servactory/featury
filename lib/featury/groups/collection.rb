# frozen_string_literal: true

module Featury
  module Groups
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :flat_map, :filter, :to_h, :merge, :to_a, :all?, :empty?

      def initialize(collection = Set.new)
        @collection = collection
      end
    end
  end
end
