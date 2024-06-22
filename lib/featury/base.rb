# frozen_string_literal: true

module Featury
  class Base
    include Context::DSL
    include Actions::DSL
    include Groups::DSL
    include Features::DSL
    include Conditions::DSL
    include Resources::DSL
  end
end
