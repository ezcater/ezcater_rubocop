# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireFeatureFlagMock, :config do
  subject(:cop) { described_class.new }

  it "accepts usage of the mock_feature_flag helper with no options" do
    expect_no_offenses <<~RUBY
      mock_feature_flag("MyFeatureFlag", true)
    RUBY
  end

  it "accepts usage of the mock_feature_flag helper with options" do
    expect_no_offenses <<~RUBY
      user = create(:user)
      mock_feature_flag("MyFeatureFlag", { user: user }, true)
    RUBY
  end

  it "accepts usage of FeatureFlag constant when validating mocked calls" do
    expect_no_offenses <<~RUBY
      expect(FeatureFlag).to have_received(:is_active?).and_return(true)
    RUBY
  end

  it "registers an offense when attempting to directly mock FeatureFlag" do
    expect_offense <<~RUBY
      allow(FeatureFlag).to receive(:is_active?).and_return(true)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/RspecRequireFeatureFlagMock: Use the `mock_feature_flag` helper instead of mocking `allow(FeatureFlag)`
    RUBY
  end

  it "registers an offense when attempting to directly mock FeatureFlag with bad formatting" do
    expect_offense <<~RUBY
      allow   (    FeatureFlag  ).to receive(:is_active?).and_return(true)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/RspecRequireFeatureFlagMock: Use the `mock_feature_flag` helper instead of mocking `allow(FeatureFlag)`
    RUBY
  end
end
