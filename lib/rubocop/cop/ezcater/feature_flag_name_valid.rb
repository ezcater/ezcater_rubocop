# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Match the naming validations in the feature flag service.
      #
      # @example
      #
      #   # good
      #   EzFF.active?("Foo::Bar")
      #   EzFF.active?("Foo::Bar::Baz")
      #   MY_FLAG="Foo::Bar"; EzFF.active?(MY_FLAG)
      #
      #   # bad
      #   EzFF.active?("Foo:Bar")
      #   EzFF.active?("Foo:::Bar")
      #   EzFF.active?("Foo:Bar:Baz")
      #   EzFF.active?("Foo::Bar  ")
      #   EzFF.active?("Foo::Bar && rm -rf * ")
      #   EzFF.active?("foo::bar")
      #   MY_FLAG="Foo:bar"
      class FeatureFlagNameValid < Cop
        WHITESPACE = /\s/.freeze
        ISOLATED_COLON = /(?<!:):(?!:)/.freeze
        TRIPLE_COLON = /:::/.freeze
        INVALID_CHARACTERS = /[^a-zA-Z0-9:]/.freeze
        TITLECASE_SEGMENT = /^([A-Z][a-z0-9]*)+$/.freeze

        WHITESPACE_MSG = "Feature flag names must not contain whitespace."
        DOUBLE_COLON_MSG = "Feature flag names must use double colons (::) as namespace separators."
        INVALID_CHARACTERS_MSG = "Feature flag names must only contain alphanumeric characters and colons."
        TITLECASE_SEGMENT_MSG = "Feature flag names must use titlecase for each segment."

        def_node_matcher :feature_flag_constant_assignment, <<~PATTERN
          (casgn nil? $_ (str $_))
        PATTERN

        def_node_matcher :feature_flag_method_call, <<~PATTERN
          (send
            (_ _ {:EzFF :EzcaterFeatureFlag}) {:active? | :at_100? | :random_sample_active?} (str $_ ...))
        PATTERN

        def on_casgn(node)
          feature_flag_constant_assignment(node) do |const_name, flag_name|
            if const_name.end_with?("_FLAG")
              errors = find_name_violations(flag_name)
              add_offense(node, location: :expression, message: errors.join(", ")) if errors.any?
            end
          end
        end

        def on_send(node)
          return unless feature_flag_method_call(node)
            
          feature_flag_method_call(node) do |flag_name|
            errors = find_name_violations(flag_name)
            add_offense(node, location: :expression, message: errors.join(", ")) if errors.any?
          end
        end

        private

        def find_name_violations(name)
          errors = []

          if name.match?(WHITESPACE)
            errors << WHITESPACE_MSG
          end

          if name.match?(ISOLATED_COLON) || name.match?(TRIPLE_COLON)
            errors << DOUBLE_COLON_MSG
          end

          if name.match?(INVALID_CHARACTERS)
            errors << INVALID_CHARACTERS_MSG
          end

          name.split(/:+/).each do |segment|
            unless segment.match?(TITLECASE_SEGMENT)
              errors << TITLECASE_SEGMENT_MSG
              break
            end
          end

          errors
        end
      end
    end
  end 
end
