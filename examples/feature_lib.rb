# frozen_string_literal: true

# This is a simple class intended for use in RSpec.
class FeatureLib
  def self.enabled?(name, *arguments)
    new(name).enabled?(*arguments)
  end

  def self.disabled?(name, *arguments)
    new(name).disabled?(*arguments)
  end

  def self.enable(name, *arguments)
    new(name).enable(*arguments)
  end

  def self.disable(name, *arguments)
    new(name).disable(*arguments)
  end

  def initialize(name)
    @name = name
    @flag = true
  end

  def enabled?(*_arguments)
    @flag
  end

  def disabled?(*_arguments)
    !@flag
  end

  def enable(*_arguments)
    @flag = true
  end

  def disable(*_arguments)
    @flag = false
  end
end
