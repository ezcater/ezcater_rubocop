# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecMatchOrderedArray, :config do
  subject(:cop) { described_class.new(config) }

  it "accepts usage of `match_ordered_array`" do
    source = "expect(foo).to match_ordered_array([1, 2])"

    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it "accepts usage of `match_ordered_array without` method parens" do
    source = "expect(foo).to match_ordered_array [1, 2]"

    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it "accepts usage of `eq` without an array" do
    source = "expect(foo).to eq(1, 'foo', :baz, nil)"

    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it "corrects when using `eq` matcher for arrays" do
    source = "expect(foo).to eq([1, 'bar'])"

    inspect_source(source)

    expect(cop.highlights).to match_array("eq([1, 'bar'])")
    expect(cop.messages).to match_array(described_class::MSG)
    expect(autocorrect_source(source)).to eq("expect(foo).to match_ordered_array([1, 'bar'])")
  end

  it "corrects when using `eq` matcher for arrays without parens" do
    source = "expect(foo).to eq [nil, :baz]"

    inspect_source(source)

    expect(cop.highlights).to match_array("eq [nil, :baz]")
    expect(cop.messages).to match_array(described_class::MSG)
    expect(autocorrect_source(source)).to eq("expect(foo).to match_ordered_array [nil, :baz]")
  end
end
