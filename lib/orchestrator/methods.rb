require 'dry/monads/result'
require 'orchestrator/stack'
require 'pry'
module Orchestrator
  module Methods
    include Dry::Monads::Result::Mixin

    def initialize(steps: self.class.steps)
      @stack = Stack.new(steps)
    end

    def call(input)
      @stack.call(Success(input))
    end
  end
end
