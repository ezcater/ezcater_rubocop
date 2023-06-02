# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples_for "a browser class that should be mocked" do |klass|
  let(:error_message) { format("Ezcater/RspecRequireBrowserMock: #{described_class::MSG}", node_source: klass) }

  context "when the class is '#{klass}'" do
    it "registers an offense when attempting to directly mock #{klass}" do
      source = "allow(#{klass}).to receive(:new).with(\"My User Agent\", language: \"en=US,en\")"
      inspect_source(source)
      expect(cop.messages).to match_array([error_message])
      expect(cop.highlights).to match_array([source])
    end

    it "registers an offense when attempting to directly mock #{klass} when badly formatted" do
      source = "allow    (   #{klass}   ).to receive(:new).with(\"My User Agent\", language: \"en=US,en\")"
      inspect_source(source)
      expect(cop.messages).to match_array([error_message])
      expect(cop.highlights).to match_array([source])
    end

    it "accepts usage of #{klass} when nested beneath another constant" do
      source = "allow(SomeOtherClass::#{klass}).to receive(:new).with(\"My User Agent\", language: \"en=US,en\")"
      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end
end

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireBrowserMock, :config do
  subject(:cop) { described_class.new }

  it "accepts usage of the mock_ezcater_app helper with no options" do
    inspect_source("browser = mock_ezcater_app")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_ezcater_app helper with options" do
    inspect_source(
      "browser = mock_ezcater_app(device: \"iPhone\", version: \"1.2\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_chrome_browser helper with no options" do
    inspect_source("browser = mock_chrome_browser")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_chrome_browser helper with options" do
    inspect_source(
      "browser = mock_chrome_browser(device: \"iPhone\", version: \"1.2\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_custom_browser helper with no options" do
    inspect_source("browser = mock_custom_browser")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_custom_browser helper with options" do
    inspect_source(
      "browser = mock_custom_browser(usage_agent: \"Custom Agent\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of Browser constant when validating mocked calls" do
    inspect_source(
      "expect(Browser).to have_received(:new).with(\"My User Agent\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it_behaves_like "a browser class that should be mocked", "Browser"
  it_behaves_like "a browser class that should be mocked", "EzBrowser"
end
