# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RequireCustomError, :config do
  it "registers offense for raising StandardError class without message argument" do
    expect_offense <<~RUBY
      raise StandardError
      ^^^^^^^^^^^^^^^^^^^ Use a custom error class that inherits from StandardError when raising an exception
    RUBY
  end

  it "registers offense for raising StandardError class with message argument" do
    expect_offense <<~RUBY
      raise StandardError, "expected string"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use a custom error class that inherits from StandardError when raising an exception
    RUBY
  end

  it "registers offense for raising StandardError instance" do
    expect_offense <<~RUBY
      raise StandardError.new("expected string")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use a custom error class that inherits from StandardError when raising an exception
    RUBY
  end

  it "registers offense for raising ArgumentError class without message argument" do
    expect_offense <<~RUBY
      raise ArgumentError
      ^^^^^^^^^^^^^^^^^^^ Use a custom error class that inherits from StandardError when raising an exception
    RUBY
  end

  it "registers offense for raising ArgumentError class with message argument" do
    expect_offense <<~RUBY
      raise ArgumentError, "expected string"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use a custom error class that inherits from StandardError when raising an exception
    RUBY
  end

  it "registers offense for raising ArgumentError instance" do
    expect_offense <<~RUBY
      raise ArgumentError.new("expected string")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use a custom error class that inherits from StandardError when raising an exception
    RUBY
  end

  it "allows raising custom errors" do
    expect_no_offenses <<~RUBY
      raise MyCustomError
    RUBY
  end
end
