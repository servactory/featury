# frozen_string_literal: true

module Featury
  module Resources
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :filter, :to_h, :merge

      def initialize(collection = Set.new)
        @collection = collection
      end
    end
  end
end
