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

      def condition_web?
        @web == :condition
      end

      def action_web?
        @web == :action
      end

      def regular_web?
        @web == :regular
      end
    end
  end
end
