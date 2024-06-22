# frozen_string_literal: true

module Featury
  module Groups
    module Workspace
      def call!(action:, **)
        puts ":: Groups::Workspace » call!"

        super
      end
    end
  end
end
