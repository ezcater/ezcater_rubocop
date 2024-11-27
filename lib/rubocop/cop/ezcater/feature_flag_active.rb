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
      #   EzFF.active?(defined_flag_name_var, tracking_id: "brand:12345")
      #   EzFF.active?(@flag_name_ivar, tracking_id: "brand:12345")
      #   EzFF.active?(CONSTANT_NAME, tracking_id: "brand:12345")
      #   EzFF.active?(config.flag_name, tracking_id: "brand:12345")
      #
      #   # bad
      #   EzFF.active?("FlagName")
      #   EzFF.active?(defined_flag_name_var)
      #   EzFF.active?(@flag_name_ivar)
      #   EzFF.active?(:symbol_name, tracking_id: "brand:12345")
      #   EzFF.active?(123, identifiers: ["user:12345"])

      class FeatureFlagActive < Base
        MSG = "`EzFF.active?` must be called with at least one of `tracking_id` or `identifiers`"
        FIRST_PARAM_MSG = "The first argument to `EzFF.active?` must be a string literal or a variable " \
        "or constant assigned to a string"

        def_node_matcher :ezff_active_one_arg, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active? ${str lvar ivar})
        PATTERN

        def_node_matcher :args_matcher, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active?
              $_
              (_
                (pair
                  (sym {:tracking_id :identifiers})
                  _)
                ...))
        PATTERN

        def_node_matcher :first_param_bad, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active? ${sym int} ...)
        PATTERN

        def_node_matcher :method_call_matcher, <<-PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) :active? ...)
        PATTERN

        def on_send(node)
          return unless method_call_matcher(node)

          if first_param_bad(node)
            add_offense(node.loc.expression, message: FIRST_PARAM_MSG)
          end

          if ezff_active_one_arg(node) || !args_matcher(node)
            add_offense(node.loc.expression, message: MSG)
          end
        end
      end
    end
  end
end
