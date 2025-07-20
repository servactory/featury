# frozen_string_literal: true

module Featury
  module Actions
    class Action
      attr_reader :name,
                  :main,
                  :web,
                  :block

      def initialize(name, main:, web:, block:)
        @name = name
        @main = main
        @web = web
        @block = block
      end

      def main?
        @main
      end

      def web?
        @web
      end
    end
  end
end
