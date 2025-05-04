# frozen_string_literal: true

# This is a simple class intended for use in RSpec.
module Services
  module Callback
    class Base
      def self.call!(...)
        new(...).call!
      end

      def initialize(action:, features:)
        @action = action
        @features = features
      end

      def call!
        :ok
      end
    end
  end
end
