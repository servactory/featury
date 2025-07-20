# frozen_string_literal: true

module Featury
  module Actions
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def for_web
        Collection.new(filter { |action| action.main_web? || action.regular_web? })
      end

      def names
        map(&:name)
      end

      def main_web
        find(&:main_web?)
      end

      def find_by(name:)
        find { |action| action.name == name }
      end
    end
  end
end
