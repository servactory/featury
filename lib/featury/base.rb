# frozen_string_literal: true

module Featury
  class Base
    include Info::DSL
    include Context::DSL
    include Actions::DSL
    include Callbacks::DSL
    include Groups::DSL
    include Features::DSL
    include Conditions::DSL
    include Resources::DSL
  end
end
