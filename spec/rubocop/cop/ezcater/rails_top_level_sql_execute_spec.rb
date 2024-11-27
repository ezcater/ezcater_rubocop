# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RailsTopLevelSqlExecute, :config do
  it "accepts `execute`" do
    expect_no_offenses <<~RUBY
      execute('SELECT * FROM foo')
    RUBY
  end

  it "detects `ActiveRecord::Base.connection.execute`" do
    expect_offense <<~RUBY
      ActiveRecord::Base.connection.execute('SELECT * FROM foo')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `execute` instead of `ActiveRecord::Base.connection.execute` in migrations. The latter is redundant and can bypass safety checks.
    RUBY

    expect_correction <<~RUBY
      execute('SELECT * FROM foo')
    RUBY
  end

  it "detects `ActiveRecord::Base.connection.execute` with non-string arguments" do
    expect_offense <<~RUBY
      ActiveRecord::Base.connection.execute(foo_bar)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `execute` instead of `ActiveRecord::Base.connection.execute` in migrations. The latter is redundant and can bypass safety checks.
    RUBY
  end
end
