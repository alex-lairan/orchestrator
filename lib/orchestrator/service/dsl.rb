module Orchestrator
  module Service
    class DSL < Module
      def initialize
        module_eval do
          define_method(:context) { @context ||= [] }
        end

        define
      end

      def define
        module_exec do
          define_method(:attribute) do |attribute, **options|
            context << { name: attribute, options: options }
          end
        end
      end
    end
  end
end
