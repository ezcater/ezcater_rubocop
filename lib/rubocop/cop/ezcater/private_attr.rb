module RuboCop
  module Cop
    module Ezcater
      # This cop checks for the use of `attr_accessor`, `attr_reader`, `attr_writer`
      # and `alias_method` after the access modifiers `private` and `protected`
      # and requires the use of methods from the private_attr gem instead.
      #
      # @example
      #
      #   # bad
      #
      #   class C
      #     private
      #
      #     attr_accessor :foo
      #     attr_reader :bar
      #     attr_writer :baz
      #     alias_method :foobar, foo
      #   end
      #
      #
      # @example
      #
      #   # good
      #
      #   class C
      #     private_attr_accessor :foo
      #     private_attr_reader :bar
      #     private_attr_writer :baz
      #     private_alias_method :foobar, :foo
      #
      #     private
      #
      #     def shy
      #       puts "hi"
      #     end
      #   end
      class PrivateAttr < Cop
        ATTR_METHODS = %i(attr_accessor
                          attr_reader
                          attr_writer).freeze

        ACCESS_AFFECTED_METHODS = (ATTR_METHODS + %i(alias_method)).to_set.freeze

        MSG = "Use `%s_%s` instead".freeze

        def on_class(node)
          check_node(node.children[2]) # class body
        end

        def on_module(node)
          check_node(node.children[1]) # module body
        end

        private

        def check_node(node)
          return unless node&.begin_type?

          check_scope(node)
        end

        def format_message(visibility, method_name)
          format(MSG, visibility, method_name)
        end

        def check_scope(node, current_visibility = :public)
          node.children.reduce(current_visibility) do |visibility, child|
            check_child_scope(child, visibility)
          end
        end

        def check_child_scope(node, current_visibility)
          if node.send_type?
            if node.access_modifier? && !node.method?(:module_function)
              current_visibility = node.method_name
            elsif ACCESS_AFFECTED_METHODS.include?(node.method_name) && current_visibility != :public
              add_offense(node,
                          location: :expression,
                          message: format_message(current_visibility, node.method_name))
            end
          elsif node.kwbegin_type?
            check_scope(node, current_visibility)
          end

          current_visibility
        end
      end
    end
  end
end
