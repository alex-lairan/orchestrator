require 'dry/monads/result'

module Orchestrator
  class StepAdapters
    class Step
      include Dry::Monads::Result::Mixin

      def call(args, &block)
        block ||= ->{}

        block.(*args, &block)
      end
    end

    register :step, Step.new
  end
end
