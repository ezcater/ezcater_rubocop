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
        class BigintForeignKey < Base # rubocop:disable Metrics/ClassLength
          extend AutoCorrector

          MSG = <<~MSG.chomp
            Use `bigint` instead of `integer` for foreign keys. This prevents them from potentially running out of int values before their referenced primary keys.
          MSG

          # Optimization: only call `on_send` for the methods in this list
          RESTRICT_ON_SEND = %i(
            integer
            references
            belongs_to
            add_column
            add_reference
            add_belongs_to
          ).freeze

          BIGINT_BYTES = 8

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

              # A hash that includes `type: :integer`
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

              # A hash that includes `type: :integer`
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

          def check_integer_method(node, captures)
            limit_value = captures.first
            check_for_offense(node, limit_value)
          end

          def check_reference_method(node)
            limit_vals = limit_pair(node)
            limit_value = limit_vals.first

            check_for_offense(node, limit_value)
          end

          def check_for_offense(node, limit_value)
            return unless limit_value.nil? || limit_value < BIGINT_BYTES

            add_offense(node) do |corrector|
              make_correction(node, corrector)
            end
          end

          def make_correction(node, corrector)
            case node.method_name
            when :integer
              correct_integer_method(node, corrector)
            when :references, :belongs_to
              correct_references_method(node, corrector)
            when :add_column
              correct_add_column_method(node, corrector)
            when :add_reference, :add_belongs_to
              correct_add_reference_method(node, corrector)
            end
          end

          def correct_integer_method(node, corrector)
            # There's no hash argument or it has only one pair
            if node.arguments.size == 1 ||
               (node.arguments.size == 2 &&
                (node.arguments[1].hash_type? &&
                 node.arguments[1].pairs.size == 1))

              corrector.replace(
                range_for_method_and_optional_limit(node),
                "bigint #{node.arguments[0].source}"
              )
            end
          end

          def correct_references_method(node, corrector)
            # There's only one hash pair (:type) or only two: :type and :limit
            return unless node.arguments.size == 2 && node.arguments[1].hash_type?

            hash_pairs = node.arguments[1].pairs
            keys = hash_pairs.map { |pair| pair.key.source }

            if keys.size == 1 ||
               (keys.size == 2 && keys.include?("limit"))

              corrector.replace(
                range_for_method_and_optional_limit(node),
                "#{node.method_name} #{node.arguments[0].source}"
              )
            end
          end

          def correct_add_column_method(node, corrector)
            # There's no hash argument or it has only one pair (:limit)
            if node.arguments.size == 3 ||
               (node.arguments.size == 4 &&
                (node.arguments[3].hash_type? &&
                 node.arguments[3].pairs.size == 1))

              corrector.replace(
                range_for_method_and_optional_limit(node),
                "add_column #{node.arguments[0].source}, #{node.arguments[1].source}, :bigint"
              )
            end
          end

          def correct_add_reference_method(node, corrector)
            # There's only one hash pair (:type) or only two: :type and :limit
            return unless node.arguments.size == 3 && node.arguments[2].hash_type?

            hash_pairs = node.arguments[2].pairs
            keys = hash_pairs.map { |pair| pair.key.source }

            if keys.size == 1 ||
               (keys.size == 2 && keys.include?("limit"))

              corrector.replace(
                range_for_method_and_optional_limit(node),
                "#{node.method_name} #{node.arguments[0].source}, #{node.arguments[1].source}"
              )
            end
          end

          def range_for_method_and_optional_limit(node)
            Parser::Source::Range.new(
              node.source_range.source_buffer,
              node.selector.begin_pos,
              node.source_range.end_pos
            )
          end
        end
      end
    end
  end
end
