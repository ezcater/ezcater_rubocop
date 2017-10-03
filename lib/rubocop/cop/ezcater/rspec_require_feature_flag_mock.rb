module RuboCop
  module Cop
    module Ezcater
      # Enforce usage of our `mock_feature_flag` helpers over explicit usage
      # of allow(FeatureFlag) mocking.
      #
      # @example
      #
      #   # good
      #   mock_feature_flag("MyFeatureFlag", true)
      #   mock_feature_flag("MyFeatureFlag", { user: current_user }, true)
      #
      #   # bad
      #   allow(FeatureFlag).to receive(:is_active?).and_return(true)
      #   allow(FeatureFlag).to receive(:is_active?).with("MyFeatureFlag").and_return(true)
      #   allow(FeatureFlag).to receive(:is_active?).with("MyFeatureFlag", user: current_user).and_return(true)
      class RspecRequireFeatureFlagMock < Cop
        MSG = "Use the `mock_feature_flag` helper instead of mocking `allow(FeatureFlag)`".freeze

        def_node_matcher :feature_flag_const?, <<~PATTERN
          (const _ :FeatureFlag)
        PATTERN

        def on_const(node)
          return unless feature_flag_const?(node)

          # Walk to send node where method = :allow
          match_node = node
          match_node = match_node.parent while not_allow_send_node?(match_node.parent)
          match_node = match_node.parent

          # Validate send node, method = :allow; could have never been found
          return unless allow_send_node?(match_node)

          # Finish tree navigation to full line for highlighting
          match_node = match_node.parent while match_node.parent
          add_offense(match_node, :expression)
        end

        private

        def not_allow_send_node?(node)
          node && !allow_send_node?(node)
        end

        def allow_send_node?(node)
          node && node.send_type? && node.method_name == :allow
        end
      end
    end
  end
end
