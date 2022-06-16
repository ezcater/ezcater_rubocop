# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::GraphQlTypeFileOrder do
  subject(:cop) { described_class.new }

  let(:msgs) { [described_class::MSG] }

  it "enforces the required order of dsl calls" do
    source = <<~SOURCE
      class MyType
        pundit_policy_class Policies::RecipeUpdatePolicy
        description "Allow a user to update a recipe."
      end
    SOURCE

    inspect_source(source)
    expect(cop.offenses).not_to be_empty
  end

  it "enforces the expected order of methods" do
    source = <<~SOURCE
      class MyType
        def load_recipe(id)
          RecipeLoader.call(id)
        end

        pundit_policy_class Policies::RecipeUpdatePolicy
      end
    SOURCE

    inspect_source(source)
    expect(cop.offenses).not_to be_empty
  end

  it "enforces alphabetical order for defined methods" do
    source = <<~SOURCE
      class MyType
        def load_recipe(id)
          RecipeLoader.call(id)
        end

        def load_cart(id)
          CartLoader.call(id)
        end
      end
    SOURCE

    inspect_source(source)
    expect(cop.offenses).not_to be_empty
  end
end
