require "spec_helper"

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireFeatureFlagMock, :config do
  subject(:cop) { described_class.new }

  it "accepts usage of the mock_feature_flag helper with no options" do
    inspect_source(cop, "mock_feature_flag(\"MyFeatureFlag\", true)")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_feature_flag helper with options" do
    inspect_source(cop, [
      "user = create(:user)",
      "mock_feature_flag(\"MyFeatureFlag\", { user: user }, true)"
    ])
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of FeatureFlag constant when validating mocked calls" do
    inspect_source(cop, "expect(FeatureFlag).to have_received(:is_active?).and_return(true)")
    expect(cop.offenses).to be_empty
  end

  it "registers an offense when attempting to directly mock FeatureFlag" do
    inspect_source(cop, "allow(FeatureFlag).to receive(:is_active?).and_return(true)")
    expect(cop.messages).to eq([described_class::MSG])
    expect(cop.highlights).to eq(["allow(FeatureFlag).to receive(:is_active?).and_return(true)"])
  end

  it "registers an offense when attempting to directly mock FeatureFlag with bad formatting" do
    inspect_source(cop, "allow   (    FeatureFlag  ).to receive(:is_active?).and_return(true)")
    expect(cop.messages).to eq([described_class::MSG])
    expect(cop.highlights).to eq(["allow   (    FeatureFlag  ).to receive(:is_active?).and_return(true)"])
  end
end
