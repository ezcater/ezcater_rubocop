# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Use `EzcaterFeatureFlag.active?` with a tracking_id or array of identifiers
      #
      # @example
      #
      #   # good
      #   EzFF.active?("FlagName", tracking_id: "user:12345")
      #   EzFF.active?("FlagName", identifiers: ["user:12345", "user:23456"])
      #
      #   # bad
      #   EzFF.active?("FlagName")

      class FeatureFlagActive < Cop
        MSG = "`EzFF.active?` must be called with at least one of `tracking_id` or `identifiers`"

        def_node_matcher :ezff_active_one_arg, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active? (str _))
        PATTERN

        def_node_matcher :args_matcher, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active?
              (str _)
              (_
                (pair
                  (sym {:tracking_id :identifiers})
                  _)
                ...))
        PATTERN

        def_node_matcher :method_call_matcher, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active? ...)
        PATTERN

        def on_send(node)
          return unless method_call_matcher(node)

          if ezff_active_one_arg(node) || !args_matcher(node)
            add_offense(node, location: :expression, message: MSG)
          end
        end
      end
    end
  end
end
