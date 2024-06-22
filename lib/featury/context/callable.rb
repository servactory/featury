# frozen_string_literal: true

module Featury
  module Context
    module Callable
      def method_missing(method_name, *args, &block)
        action = collection_of_actions.find_by(name: method_name)

        return super if action.nil?

        context = send(:new)

        _call!(context, action)
      end

      def respond_to_missing?(method_name, *)
        collection_of_actions.names.include?(method_name) || super
      end

      private

      def _call!(context, action)
        context.send(
          :_call!,
          action: action,
          collection_of_conditions: collection_of_conditions,
          collection_of_features: collection_of_features
        )
      end
    end
  end
end
