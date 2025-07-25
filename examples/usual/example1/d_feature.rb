# frozen_string_literal: true

module Usual
  module Example1
    class DFeature < Usual::Example1::Base
      # NOTE: No prefix is specified here. Default prefix used.
      # prefix :usual_example_1_d

      resource :record, type: Usual::Example1::MainFeature::Record

      condition ->(resources:) { resources.record.id == "123" }

      # full » :usual_example_1_d_i
      feature :i, description: "D I feature"

      # full » :usual_example_1_d_ii
      feature :ii, description: "D II feature"

      # full » :usual_example_1_d_iii
      feature :iii, description: "D III feature"
    end
  end
end
