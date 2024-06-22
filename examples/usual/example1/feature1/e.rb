# frozen_string_literal: true

class Usual::Example1::Feature1::E < Usual::Example1::Base
  resource :record, type: Usual::Example1::Feature1::Record
  resource :user, type: Usual::Example1::Feature1::User

  condition ->(resources:) { resources.record.id == "123" }

  prefix :example_1_feature_1_e

  features(
    :i,   # full » :example_1_feature_1_e_i
    :ii,  # full » :example_1_feature_1_e_ii
    :iii  # full » :example_1_feature_1_e_iii
  )
end
