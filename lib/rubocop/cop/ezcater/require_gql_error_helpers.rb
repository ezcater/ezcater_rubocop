module RuboCop
  module Cop
    module Ezcater
      # Enforce use of GQLErrors helpers instead of throwing
      # GraphQL::ExecutionErrors directly
      #
      # @example
      #
      #   # good
      #   GQLErrors.summary_error("An error occurred")
      #   GQLErrors.request_error("You can't access this", 401)
      #   GQLErrors.field_error("is invalid", :first_name, "First Name")
      #   GQLErrors.field_errors_for(my_model, context)
      #   GQLErrors.field_errors_for(my_model, context, summary_error: "An error occurred")
      #   GQLErrors.field_errors_for(my_model, context, field_mapping: { first: :first_name })
      #
      #   # bad
      #   GraphQL::ExecutionError.new("An error occurred")
      #   GraphQL::ExecutionError.new("You can't access this", options: { status_code: 401 })
      class RequireGqlErrorHelpers < Cop
        MSG = "Use the helpers provided by `GQLErrors` instead of raising `GraphQL::ExecutionError` directly.".freeze

        def_node_matcher :graphql_const?, <<~PATTERN
          (const (const _ :GraphQL) :ExecutionError)
        PATTERN

        def on_const(node)
          return unless graphql_const?(node)

          add_offense(node, :expression, MSG)
        end
      end
    end
  end
end
