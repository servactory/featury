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

      def main?
        @web == :main
      end

      def web?
        @web == :use
      end
    end
  end
end
