# frozen_string_literal: true

module Featury
  module Actions
    module Workspace
      private

      def call!(action:, **)
        super

        action.block.call(features: [])
      end
    end
  end
end
