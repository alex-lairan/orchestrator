require 'dry/monads/result'
require 'orchestrator/service/dsl'
require 'orchestrator/service/methods'

module Orchestrator
  module Service
    class Builder < Module
      def included(klass)
        klass.extend(Orchestrator::Service::DSL.new)
        klass.include(Dry::Monads::Result::Mixin)
        klass.include(Orchestrator::Service::Methods)
      end
    end
  end
end
