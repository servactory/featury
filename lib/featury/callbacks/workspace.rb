# frozen_string_literal: true

module Featury
  module Callbacks
    module Workspace
      private

      def call!(collection_of_callbacks:, collection_of_features:, **)
        Featury::Callbacks::Service.call!(
          collection_of_callbacks: collection_of_callbacks.before,
          collection_of_features: collection_of_features.list
        )

        result = super

        Featury::Callbacks::Service.call!(
          collection_of_callbacks: collection_of_callbacks.after,
          collection_of_features: collection_of_features.list
        )

        result
      end
    end
  end
end
