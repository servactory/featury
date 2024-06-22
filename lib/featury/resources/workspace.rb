# frozen_string_literal: true

module Featury
  module Resources
    module Workspace
      private

      def serialize(model:, collection_of_attributes:, **)
        super

        return nil if model.nil? # NOTE: When `one` is optional and not passed

        model = Serialization::ServiceBuilder.build!(self, model, collection_of_attributes)

        Serialization::Serializator.serialize(
          model: model,
          collection_of_attributes: collection_of_attributes
        )
      end

      def deserialize(incoming_attributes:, collection_of_attributes:, **)
        super

        Deserialization::ServiceBuilder.build!(self, incoming_attributes, collection_of_attributes)
      end

      def to_model(attributes:)
        super

        attributes.each do |attribute_name, attribute_value|
          define_singleton_method(attribute_name) { attribute_value }
        end
      end
    end
  end
end
