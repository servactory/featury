# frozen_string_literal: true

module Wrong
  module Example1
    class Base < Featury::Base
      action :enabled?, web: :enabled? do |features:, **options|
        features.all? { |feature| FeatureLib.enabled?(feature, *options.values) }
      end

      action :disabled?, web: :regular do |features:, **options|
        features.any? { |feature| FeatureLib.disabled?(feature, *options.values) }
      end

      action :enable, web: :enable do |features:, **options|
        features.all? { |feature| FeatureLib.enable(feature, *options.values) }
      end

      action :disable, web: :disable do |features:, **options|
        features.all? { |feature| FeatureLib.disable(feature, *options.values) }
      end

      action :add, web: :regular do |features:, **options|
        features.all? { |feature| FeatureLib.add(feature, *options.values) }
      end

      before do |action:, features:|
        Services::Callback::Before.call!(action:, features:)
      end

      after :enabled?, :disabled? do |action:, features:|
        Services::Callback::After.call!(action:, features:)
      end
    end
  end
end
