# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Checks for `raise` on `StandardError` and `ArgumentError`.
      # We want to be explicit about the error we're raising and use a custom error
      #
      # @example
      #   # bad
      #   raise StandardError, "You can't do that"
      #
      #   # good
      #   raise OrderActionNotAllowed

      class RequireCustomError < Base
        MSG = "Use a custom error class that inherits from StandardError when raising an exception"

        def_node_matcher :raising_standard_or_argument_error,
                         "(send nil? {:raise :fail} (const nil? {:StandardError :ArgumentError} ...) ...)"

        def_node_matcher :initializing_standard_or_argument_error,
                         "(send nil? {:raise :fail} (send (const nil? {:StandardError :ArgumentError} ...) ...))"

        def on_send(node)
          raising_standard_or_argument_error(node) do
            add_offense(node, message: format(MSG))
          end

          initializing_standard_or_argument_error(node) do
            add_offense(node, message: format(MSG))
          end
        end
      end
    end
  end
end
