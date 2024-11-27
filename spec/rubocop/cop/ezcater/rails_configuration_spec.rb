# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RailsConfiguration, :config do
  it "accepts Rails.configuration" do
    expect_no_offenses <<~RUBY
      Rails.configuration.foobar
    RUBY
  end

  it "corrects Rails.application.config" do
    expect_offense <<~RUBY
      Rails.application.config.foobar
      ^^^^^^^^^^^^^^^^^^^^^^^^ Use `Rails.configuration` instead of `Rails.application.config`.
    RUBY

    expect_correction <<~RUBY
      Rails.configuration.foobar
    RUBY
  end
end
