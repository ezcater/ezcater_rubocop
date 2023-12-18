# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Enforce not using Time in an assertion
      #
      # @example
      #
      #   # good
      #   let(:current_time) { Time.zone.now } [outside of test]
      #   expect(foo).to eq(current_time)
      #
      #   # bad
      #   expect(foo).to eq(Time.zone.now)
      #   expect(foo).to eq({a: { b: Time.zone.now }})
      class RspecAssertOnCurrentTime < Cop
        MSG = "Do not call Time in an assertion. Memoize the value outside the spec and use that instead."

        def_node_matcher "expect", <<~PATTERN
          (send (send nil? :expect (...)) :to $...)
        PATTERN

        def_node_matcher "time", <<~PATTERN
          (:const nil? :Time)
        PATTERN

        def on_send(node)
          expect(node) do |expect_input|
            expect_input.each do |input|
              recursively_look_for_time(input)
            end
          end
        end

        def recursively_look_for_time(node)
          return unless node.is_a?(RuboCop::AST::Node)

          node&.children&.each do |child|
            next unless child.respond_to?(:children)

            time(child) do
              add_offense(child, location: :expression, message: MSG)
            end

            child.children.each do |inner_child|
              recursively_look_for_time(inner_child)
            end
          end
        end
      end
    end
  end
end
