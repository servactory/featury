# frozen_string_literal: true

module Featury
  module Callbacks
    module Workspace
      private

      def call!(action:, collection_of_callbacks:, collection_of_features:, **) # rubocop:disable Metrics/MethodLength
        Featury::Callbacks::Service.call!(
          action: action.name,
          callbacks: collection_of_callbacks.before,
          features: collection_of_features.list
        )

        result = super

        Featury::Callbacks::Service.call!(
          action: action.name,
          callbacks: collection_of_callbacks.after,
          features: collection_of_features.list
        )

        result
      end
    end
  end
end
