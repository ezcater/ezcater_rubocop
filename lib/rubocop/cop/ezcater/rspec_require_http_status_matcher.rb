# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Enforce use of HTTP status code matchers rather than asserting on on random numbers.
      #
      # @example
      #
      #   # good
      #   expect(response).to be_created
      #   expect(response).to be_bad_request
      #
      #   # bad
      #   expect(response).to have_http_status 201
      #   expect(response).to have_http_status 400
      class RspecRequireHttpStatusMatcher < Cop
        MSG = "Use the `have_http_status_code` matcher, like `expect(response).to have_http_status :bad_request`, "\
          "rather than `%<node_source>s`"

        def_node_matcher :response_code_assertion, <<~PATTERN
          (send (send _ :expect (send (send _ :response) :code)) :to (send _ :eq (int _)))
        PATTERN

        def on_send(node)
          return unless response_code_assertion(node)

          add_offense(node,
                      location: :expression,
                      message: format(MSG, node_source: node.source))
        end
      end
    end
  end
end
