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
        Collection.new(
          filter do |action|
            action.web_enabled? ||
              action.web_enable? ||
              action.web_disable? ||
              action.web_regular?
          end
        )
      end

      def names
        map(&:name)
      end

      def web_enabled
        find(&:web_enabled?)
      end

      def web_enable
        find(&:web_enable?)
      end

      def web_disable
        find(&:web_disable?)
      end

      def find_by(name:)
        find { |action| action.name == name }
      end
    end
  end
end
