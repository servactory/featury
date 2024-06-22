# frozen_string_literal: true

module Featury
  module Conditions
    module Workspace
      def call!(collection_of_conditions:, **)
        puts ":: Conditions::Workspace » call!"

        super && Featury::Conditions::Tools::Performer.perform!(self, collection_of_conditions)
      end
    end
  end
end
