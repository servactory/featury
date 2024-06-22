# frozen_string_literal: true

module Usual
  module Example1
    class Base < Featury::Base
      action :enabled? do |features:|
        features.all? { |feature| FeatureLib.enabled?(feature) }
      end

      action :disabled? do |features:|
        features.any? { |feature| FeatureLib.disabled?(feature) }
      end

      action :enable do |features:|
        features.all? { |feature| FeatureLib.enable(feature) }
      end

      action :disable do |features:|
        features.all? { |feature| FeatureLib.disable(feature) }
      end
    end
  end
end
