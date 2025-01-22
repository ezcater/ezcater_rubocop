# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      module Migration
        # Use `#bigint` instead of `#integer` for all foreign keys.
        #
        # @example
        #
        #   # bad
        #   create_table :foos do |t|
        #     t.integer :bar_id
        #   end
        #
        #   # bad
        #   create_table :foos do |t|
        #     t.integer :bar_id, limit: 7
        #   end
        #
        #   # good
        #   create_table :foos do |t|
        #     t.bigint :bar_id
        #   end
        #
        #   # good
        #   create_table :foos do |t|
        #     t.references :bar
        #   end
        #
        class BigintForeignKey < Base
          MSG = "To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `#bigint` instead of `#integer`."

          def ends_with_id?(str)
            str.end_with?("_id")
          end

          # @!method foreign_key_not_bigint?(node)
          def_node_matcher :foreign_key_not_bigint?, <<~PATTERN
            (send
              # Any local variable that calls an `integer` method
              (lvar _) :integer

              # The first argument is a symbol or string ending in _id
              {(sym #ends_with_id?) (str #ends_with_id?)}

              # There's optionally a hash argument that includes a limit key
              (hash <(pair (sym :limit) (int $_)) ...>)?
            )
          PATTERN

          def on_send(node)
            foreign_key_not_bigint?(node) do |captures|
              limit_value = captures.first

              if limit_value.nil? || limit_value < 8
                add_offense(node)
              end
            end
          end
        end
      end
    end
  end
end
