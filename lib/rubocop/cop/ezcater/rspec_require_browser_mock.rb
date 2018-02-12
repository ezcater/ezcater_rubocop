module RuboCop
  module Cop
    module Ezcater
      # Enforce use of `mock_ezcater_app`, `mock_chrome_browser` & `mock_custom_browser` helpers
      # instead of mocking `Browser` or `EzBrowser` directly.
      #
      # @example
      #
      #   # good
      #   mock_ezcater_app
      #   mock_chrome_browser
      #   mock_custom_browser
      #   mock_ezcater_app(device: "My Device", version: "1.2.3", language: "en=US,en")
      #   mock_chrome_browser(device: "My Device", version: "1.2.3", language: "en=US,en")
      #   mock_custom_browser(user_agent: "My Custom Agent", language: "en=US,en")
      #
      #   # bad
      #   allow(Browser).to receive...
      #   allow(EzBrowser).to receive...
      class RspecRequireBrowserMock < Cop
        MSG = "Use the mocks provided by `BrowserHelpers` instead of mocking `%<node_source>s`".freeze

        def_node_matcher :browser_const?, <<~PATTERN
          (const _ {:Browser :EzBrowser})
        PATTERN

        def on_const(node)
          return unless browser_const?(node) && node.descendants.empty?

          # Walk to send node where method = :allow
          match_node = node
          match_node = match_node.parent while not_allow_send_node?(match_node.parent)
          match_node = match_node.parent

          # Validate send node, method = :allow; could have never been found
          return unless allow_send_node?(match_node)

          # Finish tree navigation to full line for highlighting
          match_node = match_node.parent while match_node.parent
          add_offense(match_node,
                      location: :expression,
                      message: format(MSG, node_source: node.source))
        end

        private

        def not_allow_send_node?(node)
          node && !allow_send_node?(node)
        end

        def allow_send_node?(node)
          node&.send_type? && node.method_name == :allow
        end
      end
    end
  end
end
