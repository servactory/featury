# frozen_string_literal: true

module Featury
  module Actions
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def names
        map(&:name)
      end

      def find_by(name:)
        find { |action| action.name == name }
      end
    end
  end
end
