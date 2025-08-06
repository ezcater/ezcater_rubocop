# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Do not use `resolve_class_field`.
      #
      # @example
      #
      #   # bad
      #   resolve_class_field(:user, :name)
      #   resolve_class_field(:user, [:name])
      #   obj.resolve_class_field(:user, :name)
      #
      #   # good
      #   execute(EzrailsSchema, query, variables: { id: }, context: graphql_context)
      #
      #   More information: https://engportal.ezcater.com/docs/default/component/dev-handbook/technology/graphql/backend_implementation/testing/#recommendation
      #
      class RspecNoResolveClassField < Base
        MSG = "Do not use `resolve_class_field`. Use a query instead."

        def_node_matcher :resolve_class_field_call?, <<~PATTERN
          {
            (send nil? :resolve_class_field ...)
            (send _ :resolve_class_field ...)
          }
        PATTERN

        def on_send(node)
          return unless resolve_class_field_call?(node)

          add_offense(node, message: MSG)
        end
      end
    end
  end
end
