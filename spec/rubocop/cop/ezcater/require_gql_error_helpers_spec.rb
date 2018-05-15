# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Ezcater::RequireGqlErrorHelpers, :config do
  subject(:cop) { described_class.new }

  let(:error_message) { described_class::MSG }
  let(:expected_source) { "GraphQL::ExecutionError" }

  context "when attempting to directly use GraphQL::ExecutionError" do
    it "registers an offense" do
      source = "GraphQL::ExecutionError.new(\"An error occurred\")"
      inspect_source(source)
      expect(cop.messages).to match_array([error_message])
      expect(cop.highlights).to match_array([expected_source])
    end

    context "and additional options are provided" do
      it "registers an offense" do
        source = "GraphQL::ExecutionError.new(\"An error occurred\", options: { status_code: 401 })"
        inspect_source(source)
        expect(cop.messages).to match_array([error_message])
        expect(cop.highlights).to match_array([expected_source])
      end
    end
  end
end
