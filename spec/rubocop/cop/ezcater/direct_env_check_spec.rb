# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::DirectEnvCheck, :config do
  it "blocks plain ENV references" do
    expect_offense <<~RUBY
      ENV
      ^^^ Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `ENV`. Restricting environment variables references to be within application configuration makes it more obvious which env vars an application relies upon. https://ezcater.atlassian.net/wiki/x/ZIChNg
    RUBY
  end

  it "blocks ENV for interpolated string values" do
    expect_offense <<~'RUBY'
      foo("#{ENV}-bar")
             ^^^ Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `ENV`. Restricting environment variables references to be within application configuration makes it more obvious which env vars an application relies upon. https://ezcater.atlassian.net/wiki/x/ZIChNg
    RUBY
  end

  it "blocks key retrieval" do
    expect_offense <<~RUBY
      ENV["FOO"]
      ^^^ Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `ENV`. Restricting environment variables references to be within application configuration makes it more obvious which env vars an application relies upon. https://ezcater.atlassian.net/wiki/x/ZIChNg
    RUBY
  end

  it "blocks key retrieval with equality checks" do
    expect_offense <<~RUBY
      ENV["FOO"] == "true"
      ^^^ Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `ENV`. Restricting environment variables references to be within application configuration makes it more obvious which env vars an application relies upon. https://ezcater.atlassian.net/wiki/x/ZIChNg
    RUBY
  end
end
