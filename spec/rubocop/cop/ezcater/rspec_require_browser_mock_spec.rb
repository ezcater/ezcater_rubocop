# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireBrowserMock, :config do
  it "accepts usage of the mock_ezcater_app helper with no options" do
    expect_no_offenses <<~RUBY
      browser = mock_ezcater_app
    RUBY
  end

  it "accepts usage of the mock_ezcater_app helper with options" do
    expect_no_offenses <<~RUBY
      browser = mock_ezcater_app(device: "iPhone", version: "1.2", language: "en=US,en")
    RUBY
  end

  it "accepts usage of the mock_chrome_browser helper with no options" do
    expect_no_offenses <<~RUBY
      browser = mock_chrome_browser
    RUBY
  end

  it "accepts usage of the mock_chrome_browser helper with options" do
    expect_no_offenses <<~RUBY
      browser = mock_chrome_browser(device: "iPhone", version: "1.2", language: "en=US,en")
    RUBY
  end

  it "accepts usage of the mock_custom_browser helper with no options" do
    expect_no_offenses <<~RUBY
      browser = mock_custom_browser
    RUBY
  end

  it "accepts usage of the mock_custom_browser helper with options" do
    expect_no_offenses <<~RUBY
      browser = mock_custom_browser(usage_agent: "Custom Agent", language: "en=US,en")
    RUBY
  end

  context "with Browser class" do
    it "accepts usage when validating mocked calls" do
      expect_no_offenses <<~RUBY
        expect(Browser).to have_received(:new).with("My User Agent", language: "en=US,en")
      RUBY
    end

    it "registers offense when attempting to directly mock" do
      expect_offense <<~RUBY
        allow(Browser).to receive(:new).with("My User Agent", language: "en=US,en")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the mocks provided by `BrowserHelpers` instead of mocking `Browser`
      RUBY
    end

    it "registers offense when directly mocked with bad formatting" do
      expect_offense <<~RUBY
        allow    (   Browser   ).to receive(:new).with("My User Agent", language: "en=US,en")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the mocks provided by `BrowserHelpers` instead of mocking `Browser`
      RUBY
    end

    it "accepts usage when nested another constant" do
      expect_no_offenses <<~RUBY
        allow(SomeOtherClass::Browser).to receive(:new).with("My User Agent", language: "en=US,en")
      RUBY
    end
  end

  context "with EzBrowser class" do
    it "registers offense when attempting to directly mock" do
      expect_offense <<~RUBY
        allow(EzBrowser).to receive(:new).with("My User Agent", language: "en=US,en")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the mocks provided by `BrowserHelpers` instead of mocking `EzBrowser`
      RUBY
    end

    it "registers offense when directly mocked with bad formatting" do
      expect_offense <<~RUBY
        allow    (   EzBrowser   ).to receive(:new).with("My User Agent", language: "en=US,en")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the mocks provided by `BrowserHelpers` instead of mocking `EzBrowser`
      RUBY
    end

    it "accepts usage when nested another constant" do
      expect_no_offenses <<~RUBY
        allow(SomeOtherClass::EzBrowser).to receive(:new).with("My User Agent", language: "en=US,en")
      RUBY
    end
  end
end
