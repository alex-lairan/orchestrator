require 'dry/monads/result'

module Orchestrator
  class StepAdapters
    class Compose
      include Dry::Monads::Result::Mixin

      def call(input, klass:, **args, &block)
        block ||= ->(data) { data || {} }

        entity = klass.new

        result = entity.call(args.merge(block.call(input)))

        if entity.success?
          result
        else
          entity.rollback(result)
        end
      rescue StandardError => error
        entity.rollback(args.merge(block.call(input)))
        Failure(error)
      end
    end

    register :compose, Compose.new
  end
end
