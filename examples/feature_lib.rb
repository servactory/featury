# frozen_string_literal: true

# This is a simple class intended for use in RSpec.
class FeatureLib
  def self.enabled?(name)
    new(name).enabled?
  end

  def self.disabled?(name)
    new(name).disabled?
  end

  def self.enable(name)
    new(name).enable
  end

  def self.disable(name)
    new(name).disable
  end

  def initialize(name)
    @name = name
    @flag = true
  end

  def enabled?
    @flag
  end

  def disabled?
    !@flag
  end

  def enable
    @flag = true
  end

  def disable
    @flag = false
  end
end
