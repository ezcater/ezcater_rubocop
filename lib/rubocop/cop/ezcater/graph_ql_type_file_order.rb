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

        LOAD_METHOD_POSITION = ORDERED_DSL_METHODS.length
        RESOLVE_METHOD_POSITION = ORDERED_DSL_METHODS.length + 1

        METHOD_LOOKUP_LIST = ORDERED_DSL_METHODS.map { |method| ":#{method}" }.join(" | ")

        def on_class(node)
          type_dsl_calls(node).each_cons(2) do |previous, current|
            if MatchedNode.new(previous) > MatchedNode.new(current)
              msg = "#{previous.method_name} should be positioned after #{current.method_name}"
              add_offense(previous, location: :expression, message: msg)
            end
          end
        end

        private # rubocop:disable Lint/UselessAccessModifier

        def_node_search :type_dsl_calls, <<~PATTERN
          {
            (send nil? {#{METHOD_LOOKUP_LIST}}  ...)
            (block
                (send nil? {#{METHOD_LOOKUP_LIST}} (:sym _) ...) ...)
            (def ...)
          }
        PATTERN

        class MatchedNode
          include Comparable
          UNKNOWN_METHOD_SCORE = 100

          attr_reader :name

          def initialize(node)
            @name = node.method_name
          end

          def positional_score
            ORDERED_DSL_METHODS.index(name) || load_method_position || resolve_method_position || UNKNOWN_METHOD_SCORE
          end

          def load_method?
            name.start_with?("load_")
          end

          def resolve_method?
            name.start_with?("resolve_")
          end

          def <=>(other)
            if (load_method? && other.load_method?) || (resolve_method? && other.resolve_method?)
              name <=> other.name
            else
              positional_score <=> other.positional_score
            end
          end

          private

          def load_method_position
            if load_method?
              LOAD_METHOD_POSITION
            end
          end

          def resolve_method_position
            if resolve_method?
              RESOLVE_METHOD_POSITION
            end
          end
        end
      end
    end
  end
end
