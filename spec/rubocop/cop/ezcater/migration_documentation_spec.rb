# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::MigrationDocumentation, :config do
  subject(:cop) { described_class.new }

  let(:error_message) { described_class::MSG }

  it "throws an error when the comment is missing" do
    source = <<~TEXT
      # frozen_string_literal: true
    TEXT
    inspect_source(source)

    expect(cop.messages).to match_array [error_message]
  end

  it "does not throw an error when the comment is present" do
    source = <<~TEXT
      # frozen_string_literal: true
      #{described_class::MIGRATION_DOC_COMMENT}
    TEXT
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it "supports autocorrect" do
    source = <<~TEXT
      # frozen_string_literal: true
    TEXT
    expected_source = <<~TEXT
      # frozen_string_literal: true
      #{described_class::MIGRATION_DOC_COMMENT}
    TEXT
    inspect_source(source)

    expect(cop.messages).to match_array [error_message]
    expect(autocorrect_source(source)).to eq(expected_source)
  end
end
