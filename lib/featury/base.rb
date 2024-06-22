# frozen_string_literal: true

module Featury
  class Base
    include Context::DSL
    include Resources::DSL
    include MainCondition::DSL
    include Features::DSL
    include Groups::DSL
    include Actions::DSL
  end
end
