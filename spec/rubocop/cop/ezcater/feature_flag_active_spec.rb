# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::FeatureFlagActive, :config do
  subject(:cop) { described_class.new(config) }
  let(:flag_name) { "FeatureFlag #{rand(100)}" }
  let(:tracking_id) { generate_tracking_id }

  let(:msgs) { [described_class::MSG] }

  before { inspect_source(line) }

  %w(EzcaterFeatureFlag EzFF).each do |constant_name|
    describe "calling #{constant_name}.active?" do
      context "with a tracking_id" do
        let(:line) { %[#{constant_name}.active?("#{flag_name}", tracking_id: "#{tracking_id}")] }

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with an identifiers array" do
        let(:line) { %[#{constant_name}.active?("#{flag_name}", identifiers: ["#{tracking_id}"])] }

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with unexpected keyword args" do
        let(:line) { %[#{constant_name}.active?("#{flag_name}", bad_arg: ["#{tracking_id}"])] }

        it "reports an offense" do
          expect(cop.messages).to match_array(msgs)
        end
      end

      context "with no keyword args" do
        let(:line) { %[#{constant_name}.active?("#{flag_name}")] }

        it "reports an offense" do
          expect(cop.messages).to match_array(msgs)
        end
      end
    end
  end

  def generate_tracking_id
    [
      %w(user brand caterer).sample,
      rand(200)
    ].join(":")
  end
end
