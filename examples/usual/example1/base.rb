# frozen_string_literal: true

class Usual::Example1::Base < Featury::Base
  action :enabled? do |features:|
    features.all? { |feature| FeatureLib.enabled?(feature) }
  end

  action :disabled? do |features:|
    features.any? { |feature| FeatureLib.disabled?(feature) }
  end

  action :enable do |features:|
    features.each { |feature| FeatureLib.enable(feature) }
  end

  action :disable do |features:|
    features.each { |feature| FeatureLib.disable(feature) }
  end
end
