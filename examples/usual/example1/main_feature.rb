# frozen_string_literal: true

module Usual
  module Example1
    class MainFeature < Usual::Example1::Base
      Record = Struct.new(:id, keyword_init: true)
      User = Struct.new(:id, keyword_init: true)
      Thing = Struct.new(:id, keyword_init: true)

      prefix :usual_example_1

      resource :record, type: Record, nested: true
      resource :user, type: User, option: true
      resource :thing, type: Thing, option: true, required: false
      resource :comment, type: String, nested: true, required: false

      condition ->(resources:) { resources.record.id == "123" }

      # full » :usual_example_1_a
      feature :a, description: "A feature"

      # full » :usual_example_1_b
      feature :b, description: "B feature"

      # full » :usual_example_1_c
      feature :c, description: "C feature"

      group Usual::Example1::DFeature, description: "D feature group"
      group Usual::Example1::EFeature, description: "E feature group"
    end
  end
end
