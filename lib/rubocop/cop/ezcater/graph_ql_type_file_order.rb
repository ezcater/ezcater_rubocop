# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      class GraphQlTypeFileOrder < Cop
        ORDERED_DSL_METHODS = %I(
          description
          pundit_policy_class
          argument
          field
        ).freeze

        METHOD_LOOKUP_LIST = ORDERED_DSL_METHODS.map { |method| ":#{method}" }.join(" | ")

        def on_class(node)
          type_dsl_calls(node).each_cons(2) do |previous, current|
            if position(previous) > position(current)
              add_offense(node, location: :expression, message: "#{previous} calls should be positioned after #{current}")
            end
          end
        end

        def position(name)
          ORDERED_DSL_METHODS.index(name)
        end

        def_node_search :type_dsl_calls, <<~PATTERN
          {
            (send nil? ${#{METHOD_LOOKUP_LIST}}  ...)
            (block
                (send nil? ${#{METHOD_LOOKUP_LIST}} (:sym _) ...) ...)
          }
        PATTERN
      end
    end
  end
end
