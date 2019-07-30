# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::DirectEnvCheck, :config do
  subject(:cop) { described_class.new(config) }

  it "blocks plain ENV references" do
    source = "ENV"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["ENV"])
    expect(cop.messages).to match_array([described_class::MSG])
  end

  it "blocks ENV for interpolated string values" do
    source = %q(foo("#{ENV}-bar")) # rubocop:disable Lint/InterpolationCheck
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["ENV"])
    expect(cop.messages).to match_array([described_class::MSG])
  end

  it "blocks key retrieval" do
    source = 'ENV["FOO"]'
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["ENV"])
    expect(cop.messages).to match_array([described_class::MSG])
  end

  it "blocks key retrieval with equality checks" do
    source = 'ENV["FOO"] == "true"'
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["ENV"])
    expect(cop.messages).to match_array([described_class::MSG])
  end
end
