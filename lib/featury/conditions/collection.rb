# frozen_string_literal: true

module Featury
  module Conditions
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :merge, :all?

      def initialize(collection = Set.new)
        @collection = collection
      end
    end
  end
end
