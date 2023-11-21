# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::FeatureFlagActive, :config do
  subject(:cop) { described_class.new(config) }

  let(:flag_name) { "FeatureFlag #{rand(100)}" }
  let(:tracking_id) { generate_tracking_id }

  let(:msgs) { [described_class::MSG] }
  let(:first_params_msgs) { [described_class::FIRST_PARAM_MSG] }

  before { inspect_source(line) }

  %w(EzcaterFeatureFlag EzFF ::EzFF ::EzcaterFeatureFlag).each do |constant_name|
    describe "calling #{constant_name}.active?" do
      context "with a tracking_id" do
        let(:line) { %[#{constant_name}.active?("#{flag_name}", tracking_id: "#{tracking_id}")] }

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with a variable instead of a flag name" do
        let(:line) do
          %[def evaluate(my_flag_name_var)
            #{constant_name}.active?(my_flag_name_var, identifiers: ["#{tracking_id}"])
          end]
        end

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with an instance variable instead of a flag name" do
        let(:line) { %[#{constant_name}.active?(@flag_ivar, identifiers: ["#{tracking_id}"])] }

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with a constant instead of a flag name" do
        let(:line) { %[#{constant_name}.active?(FLAG_VAR, identifiers: ["#{tracking_id}"])] }

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with a dot method call instead of a flag name" do
        let(:line) { %[#{constant_name}.active?(config.flag_name, identifiers: ["#{tracking_id}"])] }

        it "does not report an offense" do
          expect(cop.offenses).to be_empty
        end
      end

      context "with a symbol instead of a flag name" do
        let(:line) { %[#{constant_name}.active?(:my_flag_sym, identifiers: ["#{tracking_id}"])] }

        it "reports an offense" do
          expect(cop.messages).to match_array(first_params_msgs)
        end
      end

      context "with an integer instead of a flag name" do
        let(:line) { %[#{constant_name}.active?(13, identifiers: ["#{tracking_id}"])] }

        it "reports an offense" do
          expect(cop.messages).to match_array(first_params_msgs)
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

  context "other lines that parse to use `send` in the AST don't get caught" do
    context "require" do
      let(:line) { 'require "bar"' }

      it "reports nothing" do
        expect(cop.offenses).to be_empty
      end
    end

    context "config blocks" do
      let(:line) do
        <<-RUBY
        Configuration.config do |config|
          config.foo = true
        end
        RUBY
      end

      it "reports nothing" do
        expect(cop.offenses).to be_empty
      end
    end
  end

  def generate_tracking_id
    [
      %w(user brand caterer).sample,
      rand(200),
    ].join(":")
  end
end
