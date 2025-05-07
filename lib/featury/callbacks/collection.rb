# frozen_string_literal: true

module Featury
  module Callbacks
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def expected_actions(include:)
        Collection.new(
          filter do |callback|
            callback.expected_actions.blank? ||
              callback.expected_actions.include?(include)
          end
        )
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
