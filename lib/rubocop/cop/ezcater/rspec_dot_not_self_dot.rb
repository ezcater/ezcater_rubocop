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

      class RspecDotNotSelfDot < Base
        include RuboCop::RSpec::Language
        extend RuboCop::RSpec::Language::NodePattern
        extend RuboCop::Cop::AutoCorrector

        RSPEC_EXAMPLE_PREFIXES = ["", "x", "f"].freeze
        EXAMPLE_GROUP_IDENTIFIERS = (RSPEC_EXAMPLE_PREFIXES.map do |prefix|
          %w(describe context feature).map { |identifier| "#{prefix}#{identifier}" }
        end.flatten + %w(example_group)).freeze
        EXAMPLE_IDENTIFIERS = (RSPEC_EXAMPLE_PREFIXES.map do |prefix|
          %w(it specify example scenario).map { |identifier| "#{prefix}#{identifier}" }
        end.flatten + %w(its focus skip)).freeze

        SELF_DOT_REGEXP = /\Aself\./.freeze # rubocop:disable Style/RedundantFreeze
        COLON_COLON_REGEXP = /\A(::)/.freeze # rubocop:disable Style/RedundantFreeze

        SELF_DOT_MSG = 'Use ".<class method>" instead of "self.<class method>" for example group description.'
        COLON_COLON_MSG = 'Use ".<class method>" instead of "::<class method>" for example group description.'

        def_node_matcher :example_group?, <<~PATTERN
          (block
            (send #rspec? {#{EXAMPLE_GROUP_IDENTIFIERS.map { |i| ":#{i}" }.join(' ')}}
              (str ...) ...
            ) ...
          )
        PATTERN

        def on_block(node)
          return unless example_group?(node)

          str_node = node.send_node.arguments[0]
          message = if str_node.value.match?(SELF_DOT_REGEXP)
                      SELF_DOT_MSG
                    elsif str_node.value.match?(COLON_COLON_REGEXP)
                      COLON_COLON_MSG
                    end

          if message
            add_offense(str_node.loc.expression, message: message) do |corrector|
              expression_end = str_node.source.match?("::") ? 3 : 6
              corrector.replace(Parser::Source::Range.new(str_node.source_range.source_buffer,
                                                          str_node.source_range.begin_pos + 1,
                                                          str_node.source_range.begin_pos + expression_end), ".")
            end
          end
        end
      end
    end
  end
end
