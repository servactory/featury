# frozen_string_literal: true

module Featury
  module Context
    module Workspace
      private

      attr_reader :action

      def _call!(action:)
        call!(action: action)
      end

      def call!(action:)
        @action = action
      end
    end
  end
end
