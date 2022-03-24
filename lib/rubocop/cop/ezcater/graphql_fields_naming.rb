# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # This cop makes sure that GraphQL fields & arguments match the supported style
      # https://git.io/JeofW
      #
      # The cop also ignores when users provide a :camelize option, because
      # the user is manually requesting to override the value
      #
      # @example
      #   # bad
      #   field :fooBar, ID, null: false
      #   argument :barBaz, ID, required: true
      #
      #   # good
      #   field :foo_bar, ID, null: true
      #   field :foo_bar, ID, null: true do
      #     argument :bar_baz, ID, required: true
      #   end
      #
      #   field :fooBar, ID, null: true, camelize: true
      #
      class GraphqlFieldsNaming < Cop
        include ConfigurableNaming

        MSG = "Use %<style>s for GraphQL fields & arguments names. " \
              "See https://git.io/JeofW for our guide. " \
              "This can be overridden with camelize."
        FIELD_ADDING_METHODS = %i(field argument).freeze
        PROCESSABLE_TYPES = %i(sym string).freeze

        def on_send(node)
          method = method_name(node)
          first_arg = node.first_argument

          return unless FIELD_ADDING_METHODS.include? method
          return unless PROCESSABLE_TYPES.include?(first_arg&.type)

          return if includes_camelize?(node)

          check_name(node, first_arg.value, node.first_argument)
        end

        alias on_super on_send
        alias on_yield on_send

        private

        def includes_camelize?(node)
          results = []
          node.last_argument.each_child_node { |arg| results << args_include_camelize?(arg) }
          results.any?
        end

        def args_include_camelize?(arg_pair)
          key_node = arg_pair.key
          _value_node = arg_pair.value

          key_node.value.match?(/camelize/)
        end

        def method_name(node)
          node.children[1]
        end

        def message(msg_style)
          format(MSG, style: msg_style)
        end
      end
    end
  end
end
