# frozen_string_literal: true

class Usual::Example1::Feature1::D < Usual::Example1::Base
  resource :record, type: Usual::Example1::Feature1::Record
  resource :user, type: Usual::Example1::Feature1::User

  condition ->(resources:) { resources.record.id == "123" }

  prefix :example_1_feature_1_d

  features(
    :i,   # full » :example_1_feature_1_d_i
    :ii,  # full » :example_1_feature_1_d_ii
    :iii  # full » :example_1_feature_1_d_iii
  )
end
