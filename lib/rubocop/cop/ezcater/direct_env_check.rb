# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Use the `Rails.configuration.x` namespace for configuration backed by
      # environment variables, rather than inspecting `ENV` directly.
      #
      # Restricting environment variables references to be within application
      # configuration makes it more obvious which env vars an application relies
      # upon. See https://ezcater.atlassian.net/wiki/x/ZIChNg.
      #
      # @example
      #
      #   # good
      #   enforce_foo! if Rails.configuration.x.foo_enforced
      #
      #   # bad
      #   enforce_foo! if ENV["FOO_ENFORCED"] == "true"
      #
      class DirectEnvCheck < Base
        MSG = <<~END_MESSAGE.split("\n").join(" ")
          Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `ENV`. Restricting
          environment variables references to be within application configuration makes it more obvious which env vars
          an application relies upon. https://ezcater.atlassian.net/wiki/x/ZIChNg
        END_MESSAGE

        def_node_matcher "env_ref", <<-PATTERN
          (const _ :ENV)
        PATTERN

        def on_const(node)
          env_ref(node) do
            add_offense(node.loc.expression, message: MSG)
          end
        end
      end
    end
  end
end
