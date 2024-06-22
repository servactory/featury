# frozen_string_literal: true

module Featury
  module Conditions
    module Tools
      class Performer
        def self.perform!(...)
          new(...).perform!
        end

        def initialize(context, collection_of_conditions)
          @context = context
          @collection_of_conditions = collection_of_conditions
        end

        def perform!
          @collection_of_conditions.all? do |condition|
            condition.block.call(resources: []) # FIXME
          end
        end
      end
    end
  end
end
