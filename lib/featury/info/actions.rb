# frozen_string_literal: true

module Featury
  module Info
    class Actions
      class Web
        attr_reader :all,
                    :main

        def initialize(collection_of_actions)
          @all = collection_of_actions.names
          @main = collection_of_actions.main.name
        end
      end

      attr_reader :all,
                  :web

      def initialize(collection_of_actions)
        @all = collection_of_actions.names
        @web = Web.new(collection_of_actions.for_web)
      end
    end
  end
end
