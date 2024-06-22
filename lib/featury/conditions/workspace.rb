# frozen_string_literal: true

module Featury
  module Conditions
    module Workspace
      def call!(collection_of_conditions:, **)
        puts ":: #{self.class.name} » Conditions::Workspace » call!"

        super
      end
    end
  end
end
