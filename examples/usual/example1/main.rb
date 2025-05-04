# frozen_string_literal: true

module Usual
  module Example1
    class Main < Usual::Example1::Base
      Record = Struct.new(:id, keyword_init: true)
      User = Struct.new(:id, keyword_init: true)

      prefix :usual_example_1

      resource :record, type: Record, nested: true
      resource :user, type: User, option: true

      condition ->(resources:) { resources.record.id == "123" }

      # full » :usual_example_1_a
      # full » :usual_example_1_b
      # full » :usual_example_1_c
      features(
        :a,
        :b,
        :c
      )

      groups(
        Usual::Example1::D,
        Usual::Example1::E
      )
    end
  end
end
