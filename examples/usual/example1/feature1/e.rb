# frozen_string_literal: true

class Usual::Example1::Feature1::E < Usual::Example1::Base
  Record = Struct.new(:id, keyword_init: true)

  resource :record, type: Record

  condition ->(resources:) do
    # resources.record.id == "777"
    true
  end

  prefix :example_1_feature_1_e

  features(
    :i,   # full » :example_1_feature_1_e_i
    :ii,  # full » :example_1_feature_1_e_ii
    :iii  # full » :example_1_feature_1_e_iii
  )
end
