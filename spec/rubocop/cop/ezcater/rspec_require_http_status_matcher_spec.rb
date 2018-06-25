# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireHttpStatusMatcher do
  subject(:cop) { described_class.new }

  it "accepts usage of the HTTP status matcher" do
    inspect_source("expect(response).to have_http_status :bad_request")
    expect(cop.offenses).to be_empty
  end

  it "registeres an offence when attempting to assert directly on the status" do
    inspect_source("expect(response.code).to eq 400")
    expect(cop.messages).to match_array(["Use the status code helper methods and predicate matchers, like "\
      "`expect(response).to be_bad_request`, rather than `expect(response.code).to eq 400`",])
  end
end
