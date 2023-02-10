# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      class GraphQlTypeFileOrder < Cop
        ORDERED_DSL_METHODS = %w(
          extend
          include
          description
          pundit_policy_class
          pundit_role
          argument
          field
          user_errors_field
        ).freeze

        LOAD_METHOD_POSITION = ORDERED_DSL_METHODS.length
        RESOLVE_METHOD_POSITION = ORDERED_DSL_METHODS.length + 1

        METHOD_LOOKUP_LIST = ORDERED_DSL_METHODS.map { |method| ":#{method}" }.join(" | ")

        def on_class(node)
          gql_offenses = []
          is_gql_type = false

          type_dsl_calls(node).each_cons(2) do |previous, current|
            previous = MatchedNode.new(previous)
            current = MatchedNode.new(current)

            if previous.dsl_method? || current.dsl_method?
              is_gql_type = true
            end

            next unless previous > current

            msg = "#{previous.name} should be positioned after #{current.name}"
            gql_offenses << { node: previous.node, message: msg }
          end

          if is_gql_type
            gql_offenses.each do |offense|
              add_offense(offense[:node], location: :expression, message: offense[:message])
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
          attr_reader :node

          def initialize(node)
            @name = node.method_name.to_s
            @node = node
          end

          def positional_score
            ORDERED_DSL_METHODS.index(name) || load_method_position || resolve_method_position || UNKNOWN_METHOD_SCORE
          end

          def load_method?
            name.start_with?("load_")
          end

          def resolve_method?
            name == "resolve"
          end

          def dsl_method?
            !(ORDERED_DSL_METHODS - %w(extend include)).index(name).nil?
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
