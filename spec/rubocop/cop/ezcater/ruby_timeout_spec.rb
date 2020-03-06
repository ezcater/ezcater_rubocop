# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RubyTimeout do
  subject(:cop) { described_class.new }

  let(:msgs) { [described_class::MSG] }

  it "detects `Timeout.timeout`" do
    source = "Timeout.timeout"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array([source])
    expect(cop.messages).to match_array(msgs)
  end

  it "accepts `Timeout::Error`" do
    source = "raise Timeout::Error"
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "accepts `AnyClass.timeout`" do
    source = "AnyClass.timeout"
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
