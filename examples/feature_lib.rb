# frozen_string_literal: true

# This is a simple class intended for use in RSpec.
class FeatureLib
  def self.enabled?(name, **options)
    new(name).enabled?(**options)
  end

  def self.disabled?(name, **options)
    new(name).disabled?(**options)
  end

  def self.enable(name, **options)
    new(name).enable(**options)
  end

  def self.disable(name, **options)
    new(name).disable(**options)
  end

  def initialize(name)
    @name = name
    @flag = true
  end

  def enabled?(**_options)
    @flag
  end

  def disabled?(**_options)
    !@flag
  end

  def enable(**_options)
    @flag = true
  end

  def disable(**_options)
    @flag = false
  end
end
