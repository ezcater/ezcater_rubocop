# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecMatchOrderedArray, :config do
  it "accepts usage of `match_ordered_array`" do
    expect_no_offenses <<~RUBY
      expect(foo).to match_ordered_array([1, 2])
    RUBY
  end

  it "accepts usage of `match_ordered_array without` method parens" do
    expect_no_offenses <<~RUBY
      expect(foo).to match_ordered_array [1, 2]
    RUBY
  end

  it "accepts usage of `eq` without an array" do
    expect_no_offenses <<~RUBY
      expect(foo).to eq(1, 'foo', :baz, nil)
    RUBY
  end

  it "corrects when using `eq` matcher for arrays" do
    expect_offense <<~RUBY
      expect(foo).to eq([1, 'bar'])
                     ^^^^^^^^^^^^^^ Use the `match_ordered_array` matcher from ezcater_matchers gem instead of `eq` when comparing collections
    RUBY

    expect_correction <<~RUBY
      expect(foo).to match_ordered_array([1, 'bar'])
    RUBY
  end

  it "corrects when using `eq` matcher for arrays without parens" do
    expect_offense <<~RUBY
      expect(foo).to eq [nil, :baz]
                     ^^^^^^^^^^^^^^ Use the `match_ordered_array` matcher from ezcater_matchers gem instead of `eq` when comparing collections
    RUBY

    expect_correction <<~RUBY
      expect(foo).to match_ordered_array [nil, :baz]
    RUBY
  end
end
