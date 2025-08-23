# frozen_string_literal: true

module Featury
  module Callbacks
    class Collection
      extend Forwardable

      def_delegators :@collection, :<<, :filter, :each, :map, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def desired_actions(include:)
        Collection.new(
          filter do |callback|
            callback.desired_actions.blank? ||
              callback.desired_actions.include?(include)
          end
        )
      end

      def before
        Collection.new(filter(&:before?))
      end

      def after
        Collection.new(filter(&:after?))
      end
    end
  end
end
