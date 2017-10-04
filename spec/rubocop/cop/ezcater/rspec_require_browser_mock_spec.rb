require "spec_helper"

RSpec.shared_examples_for "a browser class that should be mocked" do |klass|
  let(:message_constant) { described_class.const_get("#{StringManipulator.underscore(klass).upcase}_MSG") }

  context "when the class is '#{klass}'" do
    it "registers an offense when attempting to directly mock #{klass}" do
      inspect_source(
        cop,
        "allow(#{klass}).to received(:new).with(\"My User Agent\", language: \"en=US,en\")"
      )
      expect(cop.messages).to eq([message_constant])
      expect(cop.highlights).to eq([
        "allow(#{klass}).to received(:new).with(\"My User Agent\", language: \"en=US,en\")"
      ])
    end

    it "registers an offense when attempting to directly mock #{klass} when badly formatted" do
      inspect_source(
        cop,
        "allow    (   #{klass}   ).to received(:new).with(\"My User Agent\", language: \"en=US,en\")"
      )
      expect(cop.messages).to eq([message_constant])
      expect(cop.highlights).to eq(
        ["allow    (   #{klass}   ).to received(:new).with(\"My User Agent\", language: \"en=US,en\")"]
      )
    end
  end
end

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireBrowserMock, :config do
  subject(:cop) { described_class.new }

  it "accepts usage of the mock_ezcater_app helper with no options" do
    inspect_source(cop, "browser = mock_ezcater_app")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_ezcater_app helper with options" do
    inspect_source(
      cop,
      "browser = mock_ezcater_app(device: \"iPhone\", version: \"1.2\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_chrome_browser helper with no options" do
    inspect_source(cop, "browser = mock_chrome_browser")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_ezcater_app helper with options" do
    inspect_source(
      cop,
      "browser = mock_chrome_browser(device: \"iPhone\", version: \"1.2\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_custom_browser helper with no options" do
    inspect_source(cop, "browser = mock_custom_browser")
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of the mock_custom_browser helper with options" do
    inspect_source(
      cop,
      "browser = mock_custom_browser(usage_agent: \"Custom Agent\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it "accepts usage of Browser constant when validating mocked calls" do
    inspect_source(
      cop,
      "expect(Browser).to have_received(:new).with(\"My User Agent\", language: \"en=US,en\")"
    )
    expect(cop.offenses).to be_empty
  end

  it_behaves_like "a browser class that should be mocked", "Browser"
  it_behaves_like "a browser class that should be mocked", "EzBrowser"
end
