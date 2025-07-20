# frozen_string_literal: true

module Featury
  module Actions
    class Action
      attr_reader :name,
                  :web,
                  :block

      def initialize(name, web:, block:)
        @name = name
        @web = web
        @block = block
      end

      def web_enabled?
        @web == :enabled?
      end

      def web_enable?
        @web == :enable
      end

      def web_disable?
        @web == :disable
      end

      def web_regular?
        @web == :regular
      end
    end
  end
end
