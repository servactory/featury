# frozen_string_literal: true

module Featury
  module Resources
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :filter, :to_h, :merge

      def initialize(collection = Set.new)
        @collection = collection
      end

      def only_nested
        Collection.new(filter(&:nested?))
      end

      def only_option
        Collection.new(filter(&:option?))
      end

      def names
        map(&:name)
      end
    end
  end
end
