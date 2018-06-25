# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecRequireHttpStatusMatcher do
  subject(:cop) { described_class.new }

  it "accepts usage of the HTTP status matcher" do
    inspect_source(cop, "expect(response).to have_http_status :bad_request")
    expect(cop.offenses).to be_empty
  end

  it "registers an offence when attempting to assert directly on the status" do
    inspect_source(cop, "expect(response.status).to eq 400")
    expect(cop.messages).to match_array(["Use the `have_http_status` matcher, like "\
      "`expect(response).to have_http_status :bad_request`, rather than `expect(response.status).to eq 400`"])
  end

  it "registers an offence when attempting to assert directly on the code" do
    inspect_source(cop, "expect(response.code).to eq \"400\"")
    expect(cop.messages).to match_array(["Use the `have_http_status` matcher, like "\
      "`expect(response).to have_http_status :bad_request`, rather than `expect(response.code).to eq \"400\"`"])
  end
end
