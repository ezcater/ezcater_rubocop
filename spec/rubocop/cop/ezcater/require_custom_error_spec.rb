# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RequireCustomError, :config do
  subject(:cop) { described_class.new(config) }

  it "requires a custom error when raising Standard or Argument error" do
    offensive_uses = [
      "raise StandardError",
      "raise ArgumentError",
      "raise ArgumentError, 'expected string'",
      "raise StandardError.new('expected string')",
    ]

    offensive_uses.each do |offensive_use|
      inspect_source(offensive_use)

      expect(cop.offenses).not_to be_empty
      expect(cop.messages).to match_array(described_class::MSG)
    end
  end

  it "allows raising custom errors" do
    inspect_source("raise MyCustomError")

    expect(cop.offenses).to be_empty
  end
end
