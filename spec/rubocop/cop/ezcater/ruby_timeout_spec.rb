# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RubyTimeout, :config do
  it "detects `Timeout.timeout(n)`" do
    expect_offense <<~RUBY
      Timeout.timeout(n) { foo }
      ^^^^^^^^^^^^^^^^^^ `Timeout.timeout` is unsafe. Find an alternative to achieve the same goal.  Ex. Use the timeout capabilities of a networking library.  Ex. Iterate and check runtime after each iteration.
    RUBY
  end

  it "detects `::Timeout.timeout(n)`" do
    expect_offense <<~RUBY
      ::Timeout.timeout(n) { foo }
      ^^^^^^^^^^^^^^^^^^^^ `Timeout.timeout` is unsafe. Find an alternative to achieve the same goal.  Ex. Use the timeout capabilities of a networking library.  Ex. Iterate and check runtime after each iteration.
    RUBY
  end

  it "detects `Timeout.timeout(n, a)`" do
    expect_offense <<~RUBY
      Timeout.timeout(n, a) { foo }
      ^^^^^^^^^^^^^^^^^^^^^ `Timeout.timeout` is unsafe. Find an alternative to achieve the same goal.  Ex. Use the timeout capabilities of a networking library.  Ex. Iterate and check runtime after each iteration.
    RUBY
  end

  it "detects `Timeout.timeout(n, a, b)`" do
    expect_offense <<~RUBY
      Timeout.timeout(n, a, b) { foo }
      ^^^^^^^^^^^^^^^^^^^^^^^^ `Timeout.timeout` is unsafe. Find an alternative to achieve the same goal.  Ex. Use the timeout capabilities of a networking library.  Ex. Iterate and check runtime after each iteration.
    RUBY
  end

  it "detects plain `Timeout.timeout` calls" do
    expect_offense <<~RUBY
      Timeout.timeout
      ^^^^^^^^^^^^^^^ `Timeout.timeout` is unsafe. Find an alternative to achieve the same goal.  Ex. Use the timeout capabilities of a networking library.  Ex. Iterate and check runtime after each iteration.
    RUBY
  end

  it "accepts `Timeout::Error`" do
    expect_no_offenses <<~RUBY
      raise Timeout::Error
    RUBY
  end

  it "accepts `AnyClass.timeout`" do
    expect_no_offenses <<~RUBY
      AnyClass.timeout
    RUBY
  end
end
