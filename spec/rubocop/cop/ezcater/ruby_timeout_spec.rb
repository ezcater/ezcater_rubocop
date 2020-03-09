# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RubyTimeout do
  subject(:cop) { described_class.new }

  let(:msgs) { [described_class::MSG] }

  it "detects `Timeout.timeout(n)`" do
    source = "Timeout.timeout(n) { foo }"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["Timeout.timeout(n)"])
    expect(cop.messages).to match_array(msgs)
  end

  it "detects `::Timeout.timeout(n)`" do
    source = "::Timeout.timeout(n) { foo }"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["::Timeout.timeout(n)"])
    expect(cop.messages).to match_array(msgs)
  end

  it "detects `Timeout.timeout(n, a)`" do
    source = "Timeout.timeout(n, a) { foo }"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["Timeout.timeout(n, a)"])
    expect(cop.messages).to match_array(msgs)
  end

  it "detects `Timeout.timeout(n, a, b)`" do
    source = "Timeout.timeout(n, a, b) { foo }"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array(["Timeout.timeout(n, a, b)"])
    expect(cop.messages).to match_array(msgs)
  end

  it "detects plain `Timeout.timeout` calls" do
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
