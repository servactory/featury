# frozen_string_literal: true

module Usual
  module Example1
    class E < Usual::Example1::Base
      prefix :usual_example_1_e

      resource :record, type: Usual::Example1::Main::Record

      condition ->(resources:) { resources.record.id == "123" }

      # full » :usual_example_1_e_i
      # full » :usual_example_1_e_ii
      # full » :usual_example_1_e_iii
      features(
        :i,
        :ii,
        :iii
      )
    end
  end
end
