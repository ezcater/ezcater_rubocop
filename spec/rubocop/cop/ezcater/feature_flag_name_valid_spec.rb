# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::FeatureFlagNameValid, :config do
  subject(:cop) { described_class.new(config) }

  before { inspect_source(line) }
  describe "assignment to a constant" do
    %w(_FF _FLAG _FLAG_NAME _FEATURE_FLAG).each do |suffix|
      describe "assignment to a constant ending in #{suffix}" do
        context "with a valid feature flag name" do
          let(:line) { %[SOMETHING#{suffix} = "Flag1"] }
    
          it "does not report an offense" do
            expect(cop.offenses).to be_empty
          end
        end
  
        context "with an invalid feature flag name" do
          let(:line) { %[SOMETHING#{suffix} = "Foo:Bar"] }
    
          it "reports an offense" do
            expect(cop.messages).to match_array(["Feature flag names must use double colons (::) as namespace separators."])
          end
        end
      end
    end
  end

  %w(EzcaterFeatureFlag EzFF ::EzFF ::EzcaterFeatureFlag).each do |klass_name|
    %w(active? at_100? random_sample_active?).each do |method_name|
      describe "method call to #{klass_name}.#{method_name}" do
        context "with a valid feature flag name" do
          let(:line) { %[#{klass_name}.#{method_name}("Foo::Bar", tracking_id: 1234)] }

          it "does not report an offense" do
            expect(cop.offenses).to be_empty
          end
        end

        context "with an invalid feature flag name" do
          let(:line) { %[#{klass_name}.#{method_name}("Foo:bar")] }

          it "reports an offense" do
            expect(cop.messages).to match_array(
              ["Feature flag names must use double colons (::) as namespace separators., Feature flag names must use titlecase for each segment."]
            )
          end
        end
      end
    end
  end
end
