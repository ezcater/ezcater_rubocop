# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Use `execute` instead of `ActiveRecord::Base.connection.execute` in migrations. The latter is redundant and
      # can bypass migration safety checks.
      #
      # @example
      #
      #   # good
      #   execute("...")
      #
      #   # bad
      #   ActiveRecord::Base.connection.execute("...")
      #
      class RailsTopLevelSqlExecute < Cop
        MSG = <<~END_MESSAGE.split("\n").join(" ")
          Use `execute` instead of `ActiveRecord::Base.connection.execute` in migrations. The latter is
          redundant and can bypass safety checks.
        END_MESSAGE

        def_node_matcher "ar_connection_execute", <<-PATTERN
          (send (send (const (const _ :ActiveRecord) :Base) :connection) :execute _)
        PATTERN

        def on_send(node)
          ar_connection_execute(node) do
            add_offense(node, location: :expression, message: MSG)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            range = Parser::Source::Range.new(
              node.source_range.source_buffer,
              node.source_range.begin_pos,
              node.source_range.end_pos
            )

            corrector.replace(range, "execute(#{node.last_argument.source})")
          end
        end
      end
    end
  end
end
