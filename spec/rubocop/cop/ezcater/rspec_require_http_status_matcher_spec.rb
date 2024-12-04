# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireHttpStatusMatcher, :config do
  it "accepts usage of the HTTP status matcher" do
    expect_no_offenses <<~RUBY
      expect(response).to have_http_status :bad_request
    RUBY
  end

  it "registers an offence when attempting to assert directly on the status" do
    expect_offense <<~RUBY
      expect(response.status).to eq 400
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the `have_http_status` matcher, like `expect(response).to have_http_status :bad_request`, rather than `expect(response.status).to eq 400`
    RUBY
  end

  it "registers an offence when attempting to assert directly on the code" do
    expect_offense <<~RUBY
      expect(response.code).to eq "400"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the `have_http_status` matcher, like `expect(response).to have_http_status :bad_request`, rather than `expect(response.code).to eq "400"`
    RUBY
  end
end
