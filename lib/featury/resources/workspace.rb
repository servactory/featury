# frozen_string_literal: true

module Featury
  module Resources
    module Workspace
      private

      def call!(action:, **)
        puts ":: Resources::Workspace » call!"

        super
      end
    end
  end
end
