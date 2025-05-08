# frozen_string_literal: true

module Featury
  module Features
    class Feature
      def initialize(prefix, name)
        @prefix = prefix
        @name = name
      end

      def full_name
        :"#{@prefix}_#{@name}"
      end
    end
  end
end
