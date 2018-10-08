module Orchestrator
  class DSL < Module
    def initialize(step_adapters:)
      @step_adapters = step_adapters

      module_eval do
        define_method(:steps) { @step ||= [] }
      end

      define
    end

    def define
      module_exec(@step_adapters) do |adapters|
        adapters.each do |key, caller|
          define_method(key) do |name, **options|
            steps << { name: name, caller: caller, options: options }
          end
        end
      end
    end
  end
end
