# frozen_string_literal: true

module Featury
  module Features
    module Workspace
      def call!(action:, **)
        puts ":: Features::Workspace » call!"

        super
      end
    end
  end
end
