# frozen_string_literal: true

module Featury
  module Service
    class Base
      include Servactory::DSL

      configuration do
        input_exception_class Featury::Service::Exceptions::Input
        internal_exception_class Featury::Service::Exceptions::Internal
        output_exception_class Featury::Service::Exceptions::Output

        failure_class Featury::Service::Exceptions::Failure

        result_class Featury::Result

        i18n_root_key :featury

        predicate_methods_enabled false
      end
    end
  end
end
