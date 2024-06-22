# frozen_string_literal: true

module Usual
  module Example1
    class D < Usual::Example1::Base
      resource :record, type: Usual::Example1::Main::Record

      condition ->(resources:) { resources.record.id == "123" }

      prefix :example_1_d

      # full » :example_1_d_i
      # full » :example_1_d_ii
      # full » :example_1_d_iii
      features(
        :i,
        :ii,
        :iii
      )
    end
  end
end
