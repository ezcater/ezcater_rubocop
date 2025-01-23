# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      module Migration
        # Use `bigint` instead of `integer` for all foreign keys.
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
        #   # bad
        #   add_column :foos, :bar_id, :integer
        #
        #   # bad
        #   add_column :foos, :bar_id, :integer, limit: 7
        #
        #   # bad
        #   add_reference :foos, :bar, type: :integer
        #
        #   # bad
        #   add_reference :foos, :bar, type: :integer, limit: 7
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
        #   # good
        #   add_column :foos, :bar_id, :bigint
        #
        #   # good
        #   add_reference :foos, :bar
        #
        class BigintForeignKey < Base
          MSG = <<~MSG.chomp
            To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `bigint` instead of `integer`.
          MSG


          # @!method t_integer_method(node)
          def_node_matcher :t_integer_method, <<~PATTERN
            (send
              # Any local variable that calls an `integer` method
              (lvar _) :integer

              # Column name: symbol or string ending in _id
              {(sym #ends_with_id?) (str #ends_with_id?)}

              # Optional hash that includes a limit key
              (hash <(pair (sym :limit) (int $_)) ...>)?
            )
          PATTERN

          # @!method t_references_method(node)
          def_node_matcher :t_references_method, <<~PATTERN
            (send
              # Any local variable that calls a `references` or `belongs_to` method
              (lvar _) {:references :belongs_to}

              # Reference name
              {(sym _) (str _)}

              # A hash that includes :integer type
              (hash <(pair (sym :type) (sym :integer)) ...>)
            )
          PATTERN

          # @!method add_column_method(node)
          def_node_matcher :add_column_method, <<~PATTERN
            # A call to an `add_column` method
            (send nil? :add_column
              # Table name
              {(sym _) (str _)}

              # Column name: a symbol or string ending in _id
              {(sym #ends_with_id?) (str #ends_with_id?)}

              # Column type
              (sym :integer)

              # Optional hash that includes a limit key
              (hash <(pair (sym :limit) (int $_)) ...>)?
            )
          PATTERN

          # @!method add_reference_method(node)
          def_node_matcher :add_reference_method, <<~PATTERN
            # A call to a `add_reference` or `add_belongs_to` method
            (send nil? {:add_reference :add_belongs_to}
              # Table name
              {(sym _) (str _)}

              # Reference name
              {(sym _) (str _)}

              # A hash that includes :integer type
              (hash <(pair (sym :type) (sym :integer)) ...>)
            )
          PATTERN

          # @!method limit_pair(node)
          def_node_search :limit_pair, <<~PATTERN
            (pair (sym :limit) (int $_))
          PATTERN

          def on_send(node)
            t_integer_method(node) do |captures|
              check_integer_method(node, captures)
            end

            add_column_method(node) do |captures|
              check_integer_method(node, captures)
            end

            t_references_method(node) do
              check_reference_method(node)
            end

            add_reference_method(node) do
              check_reference_method(node)
            end
          end

          private

          def ends_with_id?(str)
            str.end_with?("_id")
          end

          def check_limit(node, limit_value)
            if limit_value.nil? || limit_value < 8
              add_offense(node)
            end
          end

          def check_integer_method(node, captures)
            limit_value = captures.first
            check_limit(node, limit_value)
          end

          def check_reference_method(node)
            limit_vals = limit_pair(node)
            limit_value = limit_vals.first

            check_limit(node, limit_value)
          end
        end
      end
    end
  end
end
