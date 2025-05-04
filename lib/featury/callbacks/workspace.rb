# frozen_string_literal: true

module Featury
  module Callbacks
    module Workspace
      private

      def call!(collection_of_callbacks:, collection_of_features:, **)
        Featury::Callbacks::Service.call!(
          callbacks: collection_of_callbacks.before,
          features: collection_of_features.list
        )

        result = super

        Featury::Callbacks::Service.call!(
          callbacks: collection_of_callbacks.after,
          features: collection_of_features.list
        )

        result
      end
    end
  end
end
