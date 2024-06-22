# frozen_string_literal: true

module Featury
  module Groups
    module Workspace
      def call!(action:, **)
        puts ":: #{self.class.name} » Groups::Workspace » call!"

        super
      end
    end
  end
end
