# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      module GraphQL
        # Enforces authorization for scalar GraphQL fields. It
        # identifies scalar fields by matching against the standard
        # [graphql-ruby scalar types] by default.
        #
        # [graphql-ruby scalar types]: https://graphql-ruby.org/type_definitions/scalars.html
        #
        # @safety
        #   This cop is unable to autocorrect violations as decision making is
        #   required on the part of the developer.
        #
        # @example AllowGuards: false (default)
        #   # Requires that pundit authorization is used on scalar fields.
        #   # @see https://graphql-ruby.org/authorization/pundit_integration.html#authorizing-fields
        #
        #   # bad
        #   field :secret_name, String
        #
        #   # bad
        #   field :secret_name, String
        #
        #   def secret_name
        #     SecretNameGuard.new(context, object).guard do |person|
        #       person.secret_name
        #     end
        #   end

        #   # good
        #   field :name, String, pundit_role: :owner
        #
        #   # good
        #   field :name, String, pundit_role: :view, pundit_policy_class: "SecretNamePolicy"
        #
        # @example AllowGuards: true
        #   # In addition to the pundit enforcement demonstrated in the previous
        #   # example, guard-style authentication is allowed for scalar fields
        #   # when a resolver is defined in the same class.
        #
        #   # bad
        #   field :secret_name, String
        #
        #   def secret_name
        #     "Rumplestiltskin"
        #   end
        #
        #   # good
        #   field :secret_name, String
        #
        #   def secret_name
        #     SecretNameGuard.new(context, object).guard do |person|
        #       person.secret_name
        #     end
        #   end
        #
        # @example AdditionalScalarTypes: [] (default)
        #   # This option specifies additional scalar types for this cop to pay
        #   # attention to. By default, this list is empty.
        #
        #   # bad
        #   field :secret_id, ID
        #
        #   # good (i.e. the cop doesn't pay attention to UUID by default)
        #   field :secret_id, UUID
        #
        # @example AdditionalScalarTypes: ["UUID"]
        #   # This example adds UUID to the types to observe.
        #
        #   # bad
        #   field :secret_id, UUID
        #
        #   # good
        #   field :secret_id, pundit_role: owner
        #
        # @example IgnoredFieldNames: [] (default)
        #   # This option specifies field names to ignore.
        #
        #   # bad (the field name is not in the ignore list)
        #   field :id, ID
        #
        # @example IgnoredFieldNames: ["id"]
        #   # This examples adds "id" to the list of ignored field names.
        #
        #   # good
        #   field :id, ID
        #
        class NotAuthorizedScalarField < Base
          include RuboCop::GraphQL::NodePattern

          MSG = "Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized."

          # https://graphql-ruby.org/type_definitions/scalars.html
          STANDARD_SCALAR_TYPES = %w(BigInt Boolean Float Int ID ISO8601Date ISO8601DateTime ISO8601Duration JSON
                                     String).freeze

          # @!method field_type(node)
          def_node_matcher :field_type, <<~PATTERN
            (send nil? :field _ (:const nil? $_) ...)
          PATTERN

          # @!method field_with_body_type(node)
          def_node_matcher :field_with_body_type, <<~PATTERN
            (block (send nil? :field _ (:const nil? $_) ...) ...)
          PATTERN

          # @!method field_with_guard_in_body?(node)
          def_node_matcher :field_with_guard_in_body?, <<~PATTERN
            (block
              (send nil? :field ...)
              _?
              (block
                (send
                  (send
                    (:const ...) :new
                    (send nil? :context)
                    (send nil? :object)) :guard)
                ...) ...)
          PATTERN

          # @!method field_with_pundit?(node)
          def_node_matcher :field_with_pundit?, <<~PATTERN
            (send nil? :field _ _ (hash <(pair (sym :pundit_role) _) ...>))
          PATTERN

          # @!method field_with_pundit_with_body?(node)
          def_node_matcher :field_with_pundit_with_body?, <<~PATTERN
            (block (send nil? :field _ _ (hash <(pair (sym :pundit_role) _) ...>)) ...)
          PATTERN

          # @!method contains_resolver_method_with_guard?(node)
          def_node_search :contains_resolver_method_with_guard?, <<~PATTERN
            (def %1
              (args)
              (block
                (send
                  (send
                    (:const ...) :new
                    (send nil? :context)
                    (send nil? :object)) :guard)
                ...) ...)
          PATTERN

          def on_class(node)
            body = RuboCop::GraphQL::SchemaMember.new(node).body

            each_field_node(body) do |field_node|
              check_field_for_offense(field_node, node)
            end
          end

          private

          def allow_guards?
            @_allow_guards ||= !!cop_config["AllowGuards"]
          end

          def check_field_for_offense(field, class_node)
            return if field_with_pundit?(field.node) || field_with_pundit_with_body?(field.node)
            return if ignored_field_names.include?(field.underscore_name)

            type = field_type(field.node) || field_with_body_type(field.node)
            return unless scalar_types.include?(type.to_s)

            return if allow_guards? && (
                        field_with_guard_in_body?(field.node) ||
                        contains_resolver_method_with_guard?(class_node, field.underscore_name.to_sym)
                      )

            add_offense(field.node)
          end

          def each_field_node(body)
            return unless body

            body.each do |node|
              yield RuboCop::GraphQL::Field.new(node) if field?(node)
            end
          end

          def ignored_field_names
            @_ignored_field_names ||= (cop_config["IgnoredFieldNames"] || []).to_set
          end

          def scalar_types
            return @_scalar_types if defined?(@_scalar_types)

            additional_scalar_types = cop_config["AdditionalScalarTypes"] || []
            @_scalar_types = STANDARD_SCALAR_TYPES.to_set.merge(additional_scalar_types)
          end
        end
      end
    end
  end
end
