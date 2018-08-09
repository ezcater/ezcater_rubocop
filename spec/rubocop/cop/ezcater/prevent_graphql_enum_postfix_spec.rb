# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Ezcater::PreventGraphqlEnumPostfix, :config do
  subject(:cop) { described_class.new }

  let(:error_message) { described_class::MSG }
  let(:source) do
    <<~CODE
      Enums::#{expected_highlight} = GraphQL::EnumType.define do
        # other code here
      end
    CODE
  end

  before do
    inspect_source(source)
  end

  context "when the name of the Enum ends in 'Enum'" do
    let(:expected_highlight) { "ThisIsBadEnum" }

    it "registers an offense" do
      expect(cop.messages).to match_array([error_message])
      expect(cop.highlights).to match_array([expected_highlight])
    end
  end

  context "when the name of the Enum does not end in 'Enum'" do
    let(:expected_highlight) { "ThisIsGood" }

    it "does not regeister an offense" do
      expect(cop.offenses).to be_empty
    end
  end
end
