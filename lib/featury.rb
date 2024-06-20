# frozen_string_literal: true

require "zeitwerk"

require "active_support/all"

require "servactory"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "dsl" => "DSL"
)
loader.setup

module Featury; end

require "featury/engine" if defined?(Rails::Engine)
