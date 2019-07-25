# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RailsEnv, :config do
  subject(:cop) { described_class.new(config) }

  it "allows plain Rails.env references" do
    source = "Rails.env"
    inspect_source(source)
    expect(cop.offenses).to be_empty
    expect(cop.highlights).to be_empty
  end

  it "allows Rails.env for interpolated string values" do
    source = %q(foo("#{Rails.env}-bar")) # rubocop:disable Lint/InterpolationCheck
    inspect_source(source)
    expect(cop.offenses).to be_empty
    expect(cop.highlights).to be_empty
  end

  it "blocks specific env checks via Rails.env" do
    source = "Rails.env.development?"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array([source])
    expect(cop.messages).to match_array([described_class::MSG])

    %w(production staging foo).each do |env_str|
      inspect_source("Rails.env.#{env_str}?")
      expect(cop.offenses).not_to be_empty
    end
  end

  it "blocks equality checks" do
    source = "Rails.env == 'development'"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array([source])
  end

  it "does not support autocorrect" do
    source = "Rails.env.development?"
    inspect_source(source)
    expect(cop.highlights).to match_array([source])
    expect(cop.messages).to match_array([described_class::MSG])
    expect(autocorrect_source(source)).to eq(source)
  end
end
