# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Prevent use of an 'Enum' postfix when naming GraphQL Enums
      #
      # @example
      #
      #   # good
      #   Enums:ThisIsGood = GraphQL::EnumType.define do
      #     name "ThisIsGood"
      #
      #     # Other configuration here
      #   end
      #
      #   # bad
      #   Enums:ThisIsBadEnum = GraphQL::EnumType.define do
      #     name "ThisIsBadEnum"
      #
      #     # Other configuration here
      #   end
      class PreventGraphqlEnumPostfix < Cop
        MSG = "The name of your Enum should not be postfixed with 'Enum'"

        def_node_matcher :graphql_enum?, <<~PATTERN
          (casgn (const nil? :Enums) $_enum_name ...)
        PATTERN

        def on_casgn(node)
          enum_name = graphql_enum?(node)

          return unless enum_name&.to_s&.end_with?("Enum")

          add_offense(node, location: :name, message: MSG)
        end
      end
    end
  end
end
