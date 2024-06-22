# frozen_string_literal: true

class Usual::Example1::Feature1::D < Usual::Example1::Base
  Record = Struct.new(:id, keyword_init: true)

  resource :record, type: Record

  condition ->(resources:) do
    # resources.record.id == "777"
    true
  end

  prefix :example_1_feature_1_d

  features(
    :i,   # full » :example_1_feature_1_d_i
    :ii,  # full » :example_1_feature_1_d_ii
    :iii  # full » :example_1_feature_1_d_iii
  )
end
