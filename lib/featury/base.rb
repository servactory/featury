# frozen_string_literal: true

module Featury
  class Base
    include Context::DSL
    include Resources::DSL
    include Conditions::DSL
    include Features::DSL
    include Groups::DSL
    include Actions::DSL
  end
end
