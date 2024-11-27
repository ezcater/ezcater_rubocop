# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Don't use Timeout.timeout because it can cause transient errors
      #
      # @example
      #   # bad
      #   Timeout.timeout(5) do
      #     ...
      #   end
      #
      #   # good
      #   expiry_time = Time.current + 5.seconds
      #   while Time.current < expiry_time
      #     ...
      #   end
      #
      class RubyTimeout < Base
        MSG = <<~END_MESSAGE.split("\n").join(" ")
          `Timeout.timeout` is unsafe. Find an alternative to achieve the same goal.
           Ex. Use the timeout capabilities of a networking library.
           Ex. Iterate and check runtime after each iteration.
        END_MESSAGE

        def_node_matcher "timeout", <<-PATTERN
          (send (const _ :Timeout) :timeout ...)
        PATTERN

        def on_send(node)
          timeout(node) do
            add_offense(node.loc.expression, message: MSG)
          end
        end
      end
    end
  end
end
