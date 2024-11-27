# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RailsEnv, :config do
  it "allows plain Rails.env references" do
    expect_no_offenses <<~RUBY
      Rails.env
    RUBY
  end

  it "allows Rails.env for interpolated string values" do
    expect_no_offenses <<~'RUBY'
      foo("#{Rails.env}-bar")
    RUBY
  end

  %w(
    development
    foo
    production
    staging
  ).each do |environment_name|
    it "blocks specific env check '#{environment_name}' via Rails.env" do
      dynamic_highlight_width = "^" * environment_name.size

      expect_offense <<~RUBY
        Rails.env.#{environment_name}?
        ^^^^^^^^^^^#{dynamic_highlight_width} Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `Rails.env`, so that configuration is more centralized and gives finer control. https://ezcater.atlassian.net/wiki/x/ZIChNg
      RUBY
      expect_no_corrections
    end
  end

  it "blocks equality checks" do
    expect_offense <<~RUBY
      Rails.env == 'development'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `Rails.configuration.x.<foo>` for env-backed configuration instead of inspecting `Rails.env`, so that configuration is more centralized and gives finer control. https://ezcater.atlassian.net/wiki/x/ZIChNg
    RUBY
  end
end
