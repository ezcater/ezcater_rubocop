# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Use ".<class method>" instead of "self.<class method>" in RSpec example
      # group descriptions.
      #
      # @example
      #
      #   # good
      #   describe ".does_stuff" do
      #     ...
      #   end
      #
      #   # bad
      #   describe "self.does_stuff" do
      #     ...
      #   end
      #
      #   # bad
      #   describe "::does_stuff" do
      #     ...
      #   end

      class RspecDotNotSelfDot < Cop
        SELF_DOT_REGEXP = /["']self\./.freeze
        COLON_COLON_REGEXP = /["'](\:\:)/.freeze

        SELF_DOT_MSG = 'Use ".<class method>" instead of "self.<class method>" for example group description.'
        COLON_COLON_MSG = 'Use ".<class method>" instead of "::<class method>" for example group description.'

        def_node_matcher :example_group_match, <<-PATTERN
          (send _ #{RuboCop::RSpec::Language::ExampleGroups::ALL.node_pattern_union} $_ ...)
        PATTERN

        def on_send(node)
          example_group_match(node) do |doc|
            if doc.source.match?(SELF_DOT_REGEXP)
              add_offense(doc, location: :expression, message: SELF_DOT_MSG)
            elsif doc.source.match?(COLON_COLON_REGEXP)
              add_offense(doc, location: :expression, message: COLON_COLON_MSG)
            end
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            experession_end = node.source.match?(COLON_COLON_REGEXP) ? 3 : 6
            corrector.replace(Parser::Source::Range.new(node.source_range.source_buffer,
                                                        node.source_range.begin_pos + 1,
                                                        node.source_range.begin_pos + experession_end), ".")
          end
        end
      end
    end
  end
end
