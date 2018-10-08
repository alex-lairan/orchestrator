require 'dry-container'

module Orchestrator
  class StepAdapters
    extend Dry::Container::Mixin
  end
end

require 'orchestrator/steps_adapters/step'
require 'orchestrator/steps_adapters/compose'
