# frozen_string_literal: true

module Featury
  module Groups
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :filter, :to_h, :merge, :all?

      def initialize(collection = Set.new)
        @collection = collection
      end
    end
  end
end
