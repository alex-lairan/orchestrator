require 'orchestrator/step_adapters'
require 'orchestrator/dsl'
require 'orchestrator/methods'

module Orchestrator
  class Builder < Module
    attr_reader :dsl

    def initialize(adapters:)
      @dsl = Orchestrator::DSL.new(step_adapters: adapters)
    end

    def included(klass)
      klass.extend(dsl)
      klass.include(Orchestrator::Methods)
    end
  end
end
