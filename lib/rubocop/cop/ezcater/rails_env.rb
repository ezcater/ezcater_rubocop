# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Use the `Rails.configuration.x` namespace for configuration backed by
      # environment variables, rather than inspecting `Rails.env` directly.
      # Centralizing application configuration helps avoid scattering it
      # throughout the codebase, and avoids coarse environment grouping under
      # a single RAILS_ENV var. See https://ezcater.atlassian.net/wiki/x/ZIChNg.
      #
      # @example
      #
      #   # good
      #   enforce_foo! if Rails.configuration.x.foo_enforced
      #
      #   # bad
      #   foo! if Rails.env.production?

      class RailsEnv < Cop
        MSG = <<~END_MESSAGE
          Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `Rails.env`, so that
          configuration is more centralized and gives finer control. https://ezcater.atlassian.net/wiki/x/ZIChNg
        END_MESSAGE

        def_node_matcher "rails_env", <<-PATTERN
          (send (send (const _ :Rails) :env) _ ...)
        PATTERN

        def on_send(node)
          rails_env(node) do
            add_offense(node, location: :expression, message: MSG)
          end
        end
      end
    end
  end
end
