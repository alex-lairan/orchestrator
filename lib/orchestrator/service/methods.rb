module Orchestrator
  module Service
    module Methods
      def initialize(context: self.class.context)
        @context = context.map { |param| param[:name] }

        freeze
      end

      def call(input)
        data = input.select { |k, _| @context.include?(k) }
        perform(data)
      end

      def rollback(_failure)
        # no-op
      end
    end
  end
end
