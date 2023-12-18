# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecAssertOnCurrentTime, :config do
  subject(:cop) { described_class.new(config) }

  it "corrects when using Time inside expect" do
    source = "expect(foo).to match(Time.zone.now)"

    inspect_source(source)

    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array("Time")
    expect(cop.messages).to match_array(described_class::MSG)
  end

  it "corrects when using Time nested inside expect" do
    source = "expect(foo).to match({a: { b: Time.zone.now }})"

    inspect_source(source)

    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array("Time")
    expect(cop.messages).to match_array(described_class::MSG)
  end

  it "accepts when using expect without a call to Time" do
    source = "expect(foo).to match(current_time)"

    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it "accepts when using Time outside of expect" do
    source = "let(:a_time) { Time.zone.now }"

    inspect_source(source)

    expect(cop.offenses).to be_empty
  end
end
