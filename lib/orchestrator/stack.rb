require 'pry'

module Orchestrator
  class Stack
    def initialize(steps)
      @steps = steps
    end

    def call(monad)
      previous = monad

      @steps.each do |name:, caller:, options:|
        data = monad.value!.merge!(previous.value!)
        previous = caller.call(data, options)

        return previous if previous.failure?
      end

      monad
    end
  end
end
