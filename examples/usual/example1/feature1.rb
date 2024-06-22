# frozen_string_literal: true

class Usual::Example1::Feature1 < Usual::Example1::Base
  Record = Struct.new(:id, keyword_init: true)
  User = Struct.new(:id, keyword_init: true)

  resource :record, type: Record
  resource :user, type: User

  condition ->(resources:) do
    # resources.record.id == "777"
    true
  end

  prefix :example_1_feature_1

  # TODO: Нужно как-то учесть ресурс `user` и научиться передавать его в `action`.

  features(
    :a, # full » :example_1_feature_1_a
    :b, # full » :example_1_feature_1_b
    :c  # full » :example_1_feature_1_c
  )

  groups(
    Usual::Example1::Feature1::D,
    Usual::Example1::Feature1::E
  )
end
