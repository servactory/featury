# frozen_string_literal: true

module Usual
  module Example1
    class Base < Featury::Base
      action :enabled? do |features:, **options|
        features.all? { |feature| FeatureLib.enabled?(feature, *options.values) }
      end

      action :disabled? do |features:, **options|
        features.any? { |feature| FeatureLib.disabled?(feature, *options.values) }
      end

      action :enable do |features:, **options|
        features.all? { |feature| FeatureLib.enable(feature, *options.values) }
      end

      action :disable do |features:, **options|
        features.all? { |feature| FeatureLib.disable(feature, *options.values) }
      end
    end
  end
end
