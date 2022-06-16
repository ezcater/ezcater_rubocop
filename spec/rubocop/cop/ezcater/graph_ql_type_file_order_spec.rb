# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::GraphQlTypeFileOrder do
  subject(:cop) { described_class.new }

  let(:msgs) { [described_class::MSG] }

  it "enforces the required order" do
    source = <<~SOURCE
      class MyType
        pundit_policy_class Policies::RecipeUpdatePolicy
        description "Allow a user to update a recipe."
      end
    SOURCE

    inspect_source(source)
    expect(cop.offenses).not_to be_empty
  end
end
