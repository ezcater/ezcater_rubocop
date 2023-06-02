# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RailsTopLevelSqlExecute do
  subject(:cop) { described_class.new }

  let(:msgs) { ["Ezcater/RailsTopLevelSqlExecute: #{described_class::MSG}"] }

  it "accepts `execute`" do
    source = "execute('SELECT * FROM foo')"
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "detects `ActiveRecord::Base.connection.execute`" do
    source = "ActiveRecord::Base.connection.execute('SELECT * FROM foo')"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array([source])
    expect(cop.messages).to match_array(msgs)
  end

  it "detects `ActiveRecord::Base.connection.execute` with non-string arguments" do
    source = "ActiveRecord::Base.connection.execute(foo_bar)"
    inspect_source(source)
    expect(cop.offenses).not_to be_empty
    expect(cop.highlights).to match_array([source])
    expect(cop.messages).to match_array(msgs)
  end

  it "supports autocorrect" do
    source = "ActiveRecord::Base.connection.execute('SELECT * FROM foo')"
    inspect_source(source)
    expect(cop.highlights).to match_array([source])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq("execute('SELECT * FROM foo')")
  end
end
