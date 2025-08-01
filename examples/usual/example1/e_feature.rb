# frozen_string_literal: true

module Usual
  module Example1
    class EFeature < Usual::Example1::Base
      prefix :usual_example_1_e

      resource :record, type: Usual::Example1::MainFeature::Record

      condition ->(resources:) { resources.record.id == "123" }

      # full » :usual_example_1_e_i
      feature :i, description: "E I feature"

      # full » :usual_example_1_e_ii
      feature :ii, description: "E II feature"

      # full » :usual_example_1_e_iii
      feature :iii, description: "E III feature"
    end
  end
end
