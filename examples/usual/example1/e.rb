# frozen_string_literal: true

module Usual
  module Example1
    class E < Usual::Example1::Base
      resource :record, type: Usual::Example1::Main::Record
      resource :user, type: Usual::Example1::Main::User

      condition ->(resources:) { resources.record.id == "123" }

      prefix :example_1_e

      # full » :example_1_e_i
      # full » :example_1_e_ii
      # full » :example_1_e_iii
      features(
        :i,
        :ii,
        :iii
      )
    end
  end
end
