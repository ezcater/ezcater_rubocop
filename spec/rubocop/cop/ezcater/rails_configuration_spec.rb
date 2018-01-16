# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RailsConfiguration do
  subject(:cop) { described_class.new }

  let(:msgs) { [described_class::MSG] }

  it "accepts Rails.configuration" do
    source = "Rails.configuration.foobar"
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "corrects Rails.application.config" do
    source = "Rails.application.config.foobar"
    inspect_source(source)
    expect(cop.highlights).to eq(["Rails.application.config"])
    expect(cop.messages).to eq(msgs)
    expect(autocorrect_source(source)).to eq("Rails.configuration.foobar")
  end
end
