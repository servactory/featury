# frozen_string_literal: true

module Featury
  module Callbacks
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def before
        @before ||= Collection.new(filter(&:before?))
      end

      def after
        @after ||= Collection.new(filter(&:after?))
      end
    end
  end
end
