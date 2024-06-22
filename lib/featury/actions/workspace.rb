# frozen_string_literal: true

module Featury
  module Actions
    module Workspace
      private

      def call!(action:, collection_of_features:, **)
        puts ":: Actions::Workspace » call!"

        super && Featury::Actions::Tools::Performer.perform!(self, action, collection_of_features)
      end
    end
  end
end
