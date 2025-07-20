# frozen_string_literal: true

module Featury
  module Info
    class Actions
      attr_reader :all,
                  :main

      def initialize(all:, main:)
        @all = all
        @main = main
      end
    end
  end
end
