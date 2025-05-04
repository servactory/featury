# frozen_string_literal: true

module Featury
  module Callbacks
    module Workspace
      private

      def call!(collection_of_callbacks:, collection_of_features:, **) # rubocop:disable Metrics/MethodLength
        Featury::Callbacks::Service.call!(
          context: self,
          collection_of_callbacks: collection_of_callbacks.before,
          collection_of_features: collection_of_features.list
        )

        result = super

        Featury::Callbacks::Service.call!(
          context: self,
          collection_of_callbacks: collection_of_callbacks.after,
          collection_of_features: collection_of_features.list
        )

        result
      end
    end
  end
end
