# frozen_string_literal: true

module Featury
  module Groups
    class Group
      attr_reader :group_class,
                  :description

      def initialize(group:, description:)
        @group_class = group
        @description = description
      end
    end
  end
end
