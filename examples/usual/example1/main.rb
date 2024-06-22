# frozen_string_literal: true

module Usual
  module Example1
    class Main < Usual::Example1::Base
      Record = Struct.new(:id, keyword_init: true)
      User = Struct.new(:id, keyword_init: true)

      resource :record, type: Record
      resource :user, type: User

      condition ->(resources:) { resources.record.id == "123" }

      prefix :example_1_main

      # full » :example_1_main_a
      # full » :example_1_main_b
      # full » :example_1_main_c
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
