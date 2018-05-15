# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Enforce use of `match_ordered_array` matcher instead of using `eq` matcher
      #
      # @example
      #
      #   # good
      #   expect(foo).to match_ordered_array([1, 2, 3])
      #   expect(foo).to match_ordered_array [1, 2, 3]
      #
      #   # bad
      #   expect(foo).to eq([1, 2, 3])
      #   expect(foo).to eq [1, 2, 3]
      class RspecMatchOrderedArray < Cop
        MATCH_ORDERED_ARRAY = "match_ordered_array"
        MSG = "Use the `match_ordered_array` matcher from ezcater_matchers gem "\
          "instead of `eq` when comparing collections"

        def_node_matcher "eq_array", <<~PATTERN
          (send nil? :eq (array ...))
        PATTERN

        def on_send(node)
          eq_array(node) do
            add_offense(node, location: :expression, message: MSG)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(
              Parser::Source::Range.new(
                node.source_range.source_buffer,
                node.source_range.begin_pos,
                node.source_range.begin_pos + 2
              ),
              MATCH_ORDERED_ARRAY
            )
          end
        end
      end
    end
  end
end
